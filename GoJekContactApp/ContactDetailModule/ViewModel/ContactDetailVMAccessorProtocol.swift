//
//  ContactDetailVMAccessorProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation


protocol ContactDetailVMAccessorProtocol {
    func validateFields() -> Bool
    func addContact(withCompletion completion : @escaping ([AnyHashable : Any]?, Bool, CustomErrorProtocol?) -> Void)
    func updateContact(withCompletion completion : @escaping (Bool, CustomErrorProtocol?) -> Void)
}
