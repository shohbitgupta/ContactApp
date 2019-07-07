//
//  ContactDetailViewModel.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation

class ContactDetailViewModel {
    
    private let dataList : [ContactDeatilFormDataProtocol]
    var vmState : ControllerState
    var selectedContact : ContactModelProtocol?
    private var favState : Bool = false
    
    init(withState state : ControllerState, contact : ContactModelProtocol?) {
        vmState = state
        selectedContact = contact
        var dataListVal = [ContactDeatilFormDataProtocol]()
        let mappedList = state == .detail ? ["phone_number", "email"] : ["first_name", "last_name", "phone_number", "email"]
        let list = state == .detail ? ["Mobile", "Email"] : ["First Name", "Last Name", "Mobile", "Email"]
        for index in 0..<list.count {
            let val = list[index]
            let model = ContactDetailFormModel(withLeftData: val)
            let rValKey = mappedList[index]
            model.keyType = ContactDetailViewModel.getKeyboardType(fromStr: rValKey)
            if let contactData = contact as? Contact {
                model.rightData = contactData.value(forKey: rValKey) as? String
            }
            dataListVal.append(model)
        }
        dataList = dataListVal
    }
}

extension ContactDetailViewModel : TableViewAccessor {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(section : Int) -> Int {
        return dataList.count
    }
    
    subscript (index : IndexPath) -> ContactDeatilFormDataProtocol? {
        let contactDetailModel = dataList[index.row]
        return contactDetailModel
    }
}

extension ContactDetailViewModel : ContactDetailModelUpdateProtocol {
    func updateModel(atIndex index : IndexPath, withData str : String?) {
        let index = index.row
        let contactDetailModel = dataList[index]
        contactDetailModel.rightData = str
        if vmState == .edit {
            if let contact = selectedContact as? Contact {
                let mappedList = ["first_name", "last_name", "phone_number", "email"]
                let rValKey = mappedList[index]
                contact.setValue(str, forKey: rValKey)
            }
        }
    }
}

extension ContactDetailViewModel : ContactDetailActionsProtocol {
    
    func takeAction(withButtonType type : ButtonType, withStatus status : Bool, withCompletion completion : ((Bool, CustomErrorProtocol?) -> Void)?) {
        switch type {
        case .favorite:
            if validateFields() {
                updateContact { [weak self] (status, error) in
                    if let handler = completion {
                        handler(status, error)
                        self?.updateModel(favState: status)
                    }
                }
            }
            else {
                if let handler = completion {
                    handler(false, nil)
                }
            }
        default :
            print("None")
        }
    }
}

extension ContactDetailViewModel : ContactDetailVMAccessorProtocol {
    
    func validateFields() -> Bool {
        if vmState == .add {
            let mappedList = ["first_name", "last_name", "phone_number", "email"]
            for index in 0..<dataList.count {
                let val = dataList[index]
                let rValKey = mappedList[index]
                let dataVal = val.rightData ?? ""
                if dataVal.count == 0 {
                    Toast.shared().showToastMessage("Enter valid field")
                    return false
                }
                else if rValKey == "phone_number" {
                    if !dataVal.isValidatePhoneNumber() {
                        Toast.shared().showToastMessage("Enter valid Phone Number")
                        return false
                    }
                }
                else if rValKey == "email" {
                    if !dataVal.isValidEmail() {
                        Toast.shared().showToastMessage("Enter valid Email address")
                        return false
                    }
                }
            }
            return true
        }
        else {
            if let contact = selectedContact as? Contact {
                let mappedList = ["first_name", "last_name", "phone_number", "email"]
                for key in mappedList {
                    if let val = contact.value(forKey: key) as? String {
                        if val.count == 0 {
                            Toast.shared().showToastMessage("Enter valid field")
                            return false
                        }
                        else if key == "phone_number" {
                            if !val.isValidatePhoneNumber() {
                                Toast.shared().showToastMessage("Enter valid Phone Number")
                                return false
                            }
                        }
                        else if key == "email" {
                            if !val.isValidEmail() {
                                Toast.shared().showToastMessage("Enter valid Email address")
                                return false
                            }
                        }
                    }
                    else {
                        Toast.shared().showToastMessage("Enter valid field")
                        return false
                    }
                }
                return true
            }
            Toast.shared().showToastMessage("Contact is not valid")
            return false
        }
    }
    
    func addContact(withCompletion completion : @escaping ([AnyHashable : Any]?, Bool, CustomErrorProtocol?) -> Void) {
        
        if vmState == .add {
            let mappedList = ["first_name", "last_name", "phone_number", "email"]
            var info = [AnyHashable : Any]()
            for index in 0..<dataList.count {
                let val = dataList[index]
                let rValKey = mappedList[index]
                info[rValKey] = val.rightData ?? ""
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let myString = formatter.string(from: Date())
            info["created_at"] = myString
            info["updated_at"] = myString
            info["profile_pic"] = ""
            info["favorite"] = favState
            let randonVal = Int.random(in: 0..<1000000)
            info["id"] = randonVal
            
            ContactManager.addContact(withContact: info) { (data, status, error) in
                completion(data, status, error)
            }
        }
    }
    
    func updateContact(withCompletion completion : @escaping (Bool, CustomErrorProtocol?) -> Void) {
     
        if let contact = selectedContact as? Contact {
            if vmState == .edit {
                let mappedList = ["first_name", "last_name", "phone_number", "email"]
                var info = [AnyHashable : Any]()
                for index in 0..<dataList.count {
                    let val = dataList[index]
                    let rValKey = mappedList[index]
                    info[rValKey] = val.rightData ?? ""
                }
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let myString = formatter.string(from: Date())
                info["created_at"] = myString
                info["updated_at"] = myString
                info["profile_pic"] = ""
                info["favorite"] = contact.favorite
                ContactManager.updateContact(withContact: contact, contactDetail: info) { (contact, data, status, error) in
                    completion(status, error)
                }
            }
            else if vmState == .detail {
                let mappedList = ["first_name", "last_name", "phone_number", "email"]
                var info = [AnyHashable : Any]()
                for key in mappedList {
                    let val = contact.value(forKey: key)
                    info[key] = val ?? ""
                }
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let myString = formatter.string(from: Date())
                info["created_at"] = myString
                info["updated_at"] = myString
                info["profile_pic"] = ""
                info["favorite"] = contact.favorite
                ContactManager.updateContact(withContact: contact, contactDetail: info) { (contact, data, status, error) in
                    completion(status, error)
                }
            }
        }
    }
}

//Private Methods Extension

extension ContactDetailViewModel {
    private static func getKeyboardType(fromStr val : String) -> KeyBoardType {
        if val ==  "phone_number" {
            return .numberPad
        }
        else if val == "email" {
            return .email
        }
        else {
            return .normal
        }
    }
    
    private func updateModel(favState state : Bool) {
        if vmState == .edit || vmState == .detail {
            if let contact = selectedContact {
                contact.favorite = state
            }
        }
        else {
            favState = state
        }
    }
}
