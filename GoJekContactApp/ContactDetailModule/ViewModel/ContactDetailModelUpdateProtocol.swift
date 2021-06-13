//
//  ContactDetailModelUpdateProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation


protocol ContactDetailModelUpdateProtocol {
    func updateModel(atIndex index : IndexPath, withData str : String?)
}

protocol ContactDetailActionsProtocol {
    func takeAction(withButtonType type : ButtonType, withStatus status : Bool, withCompletion completion : ((Bool, CustomErrorProtocol?) -> Void)?)
}
