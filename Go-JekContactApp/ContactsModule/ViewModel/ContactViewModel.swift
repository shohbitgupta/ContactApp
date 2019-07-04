//
//  ContactViewModel.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation


class HomeContactViewModel : ContactViewModelProtocol {
    
    var dataInfo : [AnyHashable : [ContactModelProtocol]] = [:]
    var sectionTitles : [String]?
    
    func getContactList(withCompletion completion : @escaping (Bool, CustomErrorProtocol?) -> Void) {
        ContactManager.getContactList { [weak self] (list, error) in
            DispatchQueue.global().async {
                if let dataList = list {
                    var sectionTitles = Set<String>()
                    
                    for data in dataList {
                        var keyVal = String(data.fullName.prefix(1)).uppercased()
                        keyVal = keyVal.isAlphanumeric() ? keyVal : "#"
                        
                        if var contactValues = self?.dataInfo[keyVal] {
                            contactValues.append(data)
                            self?.dataInfo[keyVal] = contactValues
                        } else {
                            self?.dataInfo[keyVal] = [data]
                        }
                        sectionTitles.insert(keyVal)
                    }
                    self?.sectionTitles = sectionTitles.sorted()
                    
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let err = error ?? DataError()
                        completion(false, err)
                    }
                }
            }
        }
    }
    
    func addContact(withData response : [AnyHashable : Any]?, withCompletion completion : @escaping (Bool) -> Void) {
        DispatchQueue.global().async { [weak self] in
            if let data = response, let sectionList = self?.sectionTitles {
                let contact : ContactModelProtocol = Contact(withData: data)
                var keyVal = String(contact.fullName.prefix(1)).uppercased()
                keyVal = keyVal.isAlphanumeric() ? keyVal : "#"
                var sectionTitles = Set<String>(sectionList)
                if var contactValues = self?.dataInfo[keyVal] {
                    contactValues.append(contact)
                    self?.dataInfo[keyVal] = contactValues
                } else {
                    self?.dataInfo[keyVal] = [contact]
                }
                sectionTitles.insert(keyVal)
                self?.sectionTitles = sectionTitles.sorted()
                DispatchQueue.main.async {
                    completion(true)
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}

extension HomeContactViewModel : TableViewAccessor, TableViewOptionalAccessor {
    
    func numberOfSections() -> Int {
        return self.sectionTitles?.count ?? 0
    }
    
    func numberOfRows(section : Int) -> Int {
        if let key = sectionTitles?[section], let contactList = dataInfo[key] {
            return contactList.count
        }
        return 0
    }
    
    subscript (index : IndexPath) -> ContactModelProtocol? {
        if let key = sectionTitles?[index.section], let contactList = dataInfo[key] {
            let contact = contactList[index.row]
            return contact
        }
        return nil
    }
    
    func title(forSection section : Int) -> String? {
        let key = sectionTitles?[section]
        return key
    }
}
