//
//  ContactModelProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation

protocol ContactModelProtocol : AnyObject {
    var id : Int? { get }
    var first_name : String { get }
    var last_name : String { get }
    var fullName : String { get }
    var profile_pic : String { get }
    var url : String? { get }
    var favorite : Bool { get set }
    var phone_number : String { get }
    var email : String { get }
}
