//
//  ContactManagerProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation

protocol ContactManagerProtocol {
    static func getContactList(withCompletion completion : @escaping ([ContactModelProtocol]?, CustomErrorProtocol?) -> Void)
    static func addContact(withContact contactDetail : [AnyHashable : Any],  withCompletion completion : @escaping ([AnyHashable : Any]?, Bool, CustomErrorProtocol?) -> Void)
    static func updateContact(withContact contact : ContactModelProtocol, contactDetail : [AnyHashable : Any],  withCompletion completion : @escaping (ContactModelProtocol, [AnyHashable : Any]?, Bool, CustomErrorProtocol?) -> Void)
}
