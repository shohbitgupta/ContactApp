//
//  ImageDownloadTask.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation

/**
 This Type is used for tracking webservice made to server.
 */

class ImageDownloadTask : ImageDownloadTaskProtocol {
    
    let dataTask : URLSessionDataTask
    private let taskID : String
    private(set) var handlerList : [ImageTaskHandler] = []
    
    required init(dataTask task : URLSessionDataTask, taskID identifier : String) {
        dataTask = task
        taskID = identifier
    }
    
    func addTaskHandler(handler : ImageTaskHandler) {
        if !handlerList.contains(handler) {
            handlerList.append(handler)
        }
    }
    
    func removeHandler(handler : ImageTaskHandler) {
        if handlerList.contains(handler) {
            handlerList = handlerList.filter{ $0 != handler }
        }
    }
}
