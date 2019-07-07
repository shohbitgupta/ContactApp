//
//  ContactDetailFormDataProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation

protocol ContactDeatilFormDataProtocol : AnyObject {
    var leftData : String { get }
    var rightData : String? { get set }
    var keyType : KeyBoardType { get set }
    
}