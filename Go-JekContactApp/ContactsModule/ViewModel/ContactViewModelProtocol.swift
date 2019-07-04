//
//  ContactViewModelProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation


protocol ContactViewModelProtocol {
    var dataInfo : [AnyHashable : [ContactModelProtocol]] { get set }
    var sectionTitles : [String]? { get set }
    func getContactList(withCompletion completion : @escaping (Bool, CustomErrorProtocol?) -> Void)
    func addContact(withData response : [AnyHashable : Any]?, withCompletion completion : @escaping (Bool) -> Void)
}
