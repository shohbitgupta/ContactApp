//
//  ImageTaskHandler.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation
import UIKit

/**
 This Type is used for webservice callback made to server.
 */

class ImageTaskHandler : NSObject, ImageTaskHandlerProtocol {
    
    private(set) var dwnldID : String
    private(set) var successCallBack : (URLRequest, URLResponse?, UIImage?) -> Void
    private(set) var failureCallBack : (URLRequest, URLResponse?, CustomErrorProtocol?) -> Void
    
    required init(downloadId identifier : String, success : @escaping (URLRequest, URLResponse?, UIImage?) -> Void, failure : @escaping (URLRequest, URLResponse?, CustomErrorProtocol?) -> Void) {
        dwnldID = identifier
        successCallBack = success
        failureCallBack = failure
    }
}
