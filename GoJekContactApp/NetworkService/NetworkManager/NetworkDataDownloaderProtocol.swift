//
//  NetworkDataDownloaderProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation

protocol NetworkDataDownloaderProtocol {
    func createDataRequest(withPath path : String, withParam param: [AnyHashable : Any]?, withCustomHeader headers : [String : String]?, withRequestType type : RequestType, withCompletion completion : @escaping (Any?, CustomErrorProtocol?) -> Void)
    func cancelAllTasks()
}
