//
//  ContactManager.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation

class ContactManager : ContactManagerProtocol {
    
    static func getContactList(withCompletion completion : @escaping ([ContactModelProtocol]?, CustomErrorProtocol?) -> Void) {
        let path = WebConstant.getContactListURL
        NetworkServiceManager.sharedInstance.createDataRequest(withPath: path, withParam: nil, withCustomHeader: nil, withRequestType: .GET) { (data, error) in
            if let dataVal = data {
                DispatchQueue.global().async {
                    
                    var list : [ContactModelProtocol]?
                    
                    if let dataList = dataVal as? [Any] {
                        let builder = DataBuilder<Contact>()
                        list = builder.getParsedDataList(withData: dataList)
                    }
                    
                    DispatchQueue.main.async {
                        if let dataList = list {
                            completion(dataList, nil)
                        }
                        else {
                            let noDataError = DataError()
                            noDataError.errorMessage = Constants.noResultsErrorMessage
                            completion(nil, noDataError)
                        }
                    }
                }
            }
            else {
                let err = error ?? DataError()
                completion(nil, err)
            }
        }
    }
    
    static func addContact(withContact contactDetail : [AnyHashable : Any],  withCompletion completion : @escaping ([AnyHashable : Any]?, Bool, CustomErrorProtocol?) -> Void) {
        let path = WebConstant.addContactURL
        NetworkServiceManager.sharedInstance.createDataRequest(withPath: path, withParam: contactDetail, withCustomHeader: ["Content-Type" : "application/json"], withRequestType: .POST) { (data, error) in
            if let dataVal = data as? [AnyHashable : Any] {
                completion(dataVal, true, nil)
            }
            else {
                if let err = error {
                    completion(nil, false, err)
                }
                else {
                    completion(nil, false, DataError())
                }
            }
        }
    }
    
    static func updateContact(withContact contact : ContactModelProtocol, contactDetail : [AnyHashable : Any],  withCompletion completion : @escaping (ContactModelProtocol, [AnyHashable : Any]?, Bool, CustomErrorProtocol?) -> Void) {
        if let contactID = contact.id {
            let path = WebConstant.updateContactURL + "/\(contactID).json"
            NetworkServiceManager.sharedInstance.createDataRequest(withPath: path, withParam: contactDetail, withCustomHeader: ["Content-Type" : "application/json"], withRequestType: .PUT) { (data, error) in
                if let dataVal = data as? [AnyHashable : Any] {
                    completion(contact, dataVal, true, nil)
                }
                else {
                    if let err = error {
                        completion(contact, nil, false, err)
                    }
                    else {
                        completion(contact, nil, false, DataError())
                    }
                }
            }
        }
    }
    
}
