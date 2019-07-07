//
//  URLSessionManagerProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation


/**
 This Protocol is to provide requirements for making any object as session manager for fetching data from server.
 */

protocol URLSessionManagerProtocol {
    
    func dataTask(withURLStr urlStr : String, requestType type: RequestType, param paramVal: [AnyHashable : Any]?, headers headerVal: [String : String]?, successHander successBlock: ((URLSessionDataTask?, Any?) -> Void)?, failureHandler failureBlock: ((URLSessionDataTask?, CustomErrorProtocol?) -> Void)?) -> URLSessionDataTask?
    
    func dataTask(withRequest reuest : URLRequest, withCompletion completion : ((URLResponse?, Any?, CustomErrorProtocol?) -> Void)?) -> URLSessionDataTask
}
