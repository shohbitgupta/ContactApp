//
//  CustomControlProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation

protocol CustomControlProtocol {
    func updateView(withImage imageName : String, text : String)
}

protocol ButtonActionProtocol : AnyObject {
    func buttonTapped(sender : Any)
}
