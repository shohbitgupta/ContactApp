//
//  NetworkObjectProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation

/**
 This Protocol is to provide requirements for making any object as webservice object for tracking webservice made to server.
 */

protocol NetworkObjectProtocol {
    init(taskID identifier : String, withParam : [AnyHashable : Any]?)
}

