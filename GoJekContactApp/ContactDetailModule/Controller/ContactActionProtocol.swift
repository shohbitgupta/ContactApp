//
//  ContactActionProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation

protocol ContactActionsProtocol : AnyObject {
    func contactAdded(withContactResponse reponse : [AnyHashable : Any]?)
    func contactUpdated(status : Bool)
}

protocol UserUpdatedContactProtocol : AnyObject {
    func userUpdatedContact(status : Bool)
}
