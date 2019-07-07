//
//  NetworkServiceHandler.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation



/**
 This Protocol is to provide requirements for making any object as callback object for webservice made to server.
 */

protocol NetworkServiceHandlerProtocol {
    init(withCompletion completion : @escaping (Any?, CustomErrorProtocol?) -> Void)
}


/**
 This Type is used for webservice callback made to server.
 */

class NetworkServiceHandler : NSObject, NetworkServiceHandlerProtocol {
    let completionBlock : (Any?, CustomErrorProtocol?) -> Void
    
    required init(withCompletion completion : @escaping (Any?, CustomErrorProtocol?) -> Void) {
        completionBlock = completion
    }
}
