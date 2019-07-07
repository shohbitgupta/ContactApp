//
//  Contact.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation


import Foundation

/*
 {
 "id": 1,
 "first_name": "Amitabh",
 "last_name": "Bachchan",
 "profile_pic": "https://contacts-app.s3-ap-southeast-1.amazonaws.com/contacts/profile_pics/000/000/007/original/ab.jpg?1464516610",
 "favorite": false,
 "url": "https://gojek-contacts-app.herokuapp.com/contacts/1.json"
 }
 */

class Contact : NSObject, ContactModelProtocol, DataInitializer {
    
    let id : Int?
    @objc dynamic var first_name : String
    @objc dynamic var last_name : String
    @objc dynamic let profile_pic : String
    @objc dynamic let url : String?
    @objc dynamic var favorite : Bool
    @objc dynamic var phone_number : String
    @objc dynamic var email : String
    
    var fullName : String {
        return first_name + " " + last_name
    }
    
    required init(withData data: [AnyHashable : Any]) {
        id = data["id"] as? Int
        first_name = data["first_name"] as? String ?? Constants.noData
        last_name = data["last_name"] as? String ?? Constants.noData
        profile_pic = data["profile_pic"] as? String ?? ""
        favorite = data["favorite"] as? Bool ?? false
        url = data["url"] as? String
        phone_number = data["phone_number"] as? String ?? Constants.noData
        email = data["email"] as? String ?? Constants.noData
    }
}
