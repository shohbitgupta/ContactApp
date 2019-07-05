//
//  ContactDetailFormModel.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation


protocol ContactDetailInitializer {
    init(withLeftData lData : String)
}

enum KeyBoardType {
    case normal
    case numberPad
    case email
}

class ContactDetailFormModel : ContactDeatilFormDataProtocol, ContactDetailInitializer {
    
    let leftData : String
    var rightData : String?
    var keyType = KeyBoardType.normal
    
    required init(withLeftData lData : String) {
        leftData = lData
    }
}
