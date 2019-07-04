//
//  NetworkServiceManager.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation
import UIKit

/**
 This Type to define different type of requests.
 */

enum RequestType : String {
    case GET
    case POST
    case PUT
    case DELETE
}

/**
 This Type is used for fetching, uploading data from or to any API from the server.
 */

final class NetworkServiceManager : URLSessionManager {
    
    static let sharedInstance = NetworkServiceManager()
    private var webServiceObjectInfo : [AnyHashable : [NetworkServiceHandler]] = [:]
    private var activityCounter = 0
    private var activeRequests = Set<NetworkObject>()
    private var taskList = [URLSessionTask]()
    
    private init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.urlCache = NetworkServiceManager.urlCache()
        sessionConfig.requestCachePolicy = .useProtocolCachePolicy
        super.init(withConfiguration: sessionConfig, withBaseURL: URL(string: WebConstant.baseURL))
    }
}


extension NetworkServiceManager {
    
    private func createRequest(withPath path : String, withParam param: [AnyHashable : Any]?, withCustomHeader headers : [String : String]? , withRequestType type : RequestType, withCompletion completion : @escaping (Any?, CustomErrorProtocol?) -> Void)
    {
        let webServiceObj = NetworkObject(taskID: path, withParam: param)
        let newActiveRequests = activeRequests.filter { (object) -> Bool in
            webServiceObj.taskID == object.taskID
        }
        
        if newActiveRequests.count > 0 {
            if var completionList = webServiceObjectInfo[webServiceObj.taskID] {
                let handler = NetworkServiceHandler(withCompletion: completion)
                completionList.append(handler)
            }
            else {
                var list = [NetworkServiceHandler]()
                let handler = NetworkServiceHandler(withCompletion: completion)
                list.append(handler)
                webServiceObjectInfo[webServiceObj.taskID] = list
            }
            return
        }
        else {
            activeRequests.insert(webServiceObj)
        }
        
        let successBlock = { [weak self] (dataTask: URLSessionDataTask?, response : Any?) in
            
            guard let responseData = response as? Data else {
                let error = DataError()
                
                if let competionList = self?.webServiceObjectInfo[webServiceObj.taskID] {
                    let list = competionList as NSArray
                    let finalList = list.copy() as? [NetworkServiceHandler]
                    
                    self?.webServiceObjectInfo.removeValue(forKey: webServiceObj.taskID)
                    self?.activeRequests.remove(webServiceObj)
                    if let task = dataTask {
                        self?.removeTask(task: task)
                    }
                    
                    completion(nil, error)
                    if let handlerList = finalList {
                        for handler in handlerList {
                            handler.completionBlock(nil, error)
                        }
                    }
                }
                else {
                    self?.activeRequests.remove(webServiceObj)
                    if let task = dataTask {
                        self?.removeTask(task: task)
                    }
                    
                    completion(nil, error)
                }
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                print("jsonObject response \(jsonObject)")
                if let errData = DataError.errorObject(withResponse: jsonObject) {
                    
                    if let competionList = self?.webServiceObjectInfo[webServiceObj.taskID] {
                        
                        let list = competionList as NSArray
                        let finalList = list.copy() as? [NetworkServiceHandler]
                        
                        self?.webServiceObjectInfo.removeValue(forKey: webServiceObj.taskID)
                        self?.activeRequests.remove(webServiceObj)
                        if let task = dataTask {
                            self?.removeTask(task: task)
                        }
                        
                        completion(nil, errData)
                        if let handlerList = finalList {
                            for handler in handlerList {
                                handler.completionBlock(nil, errData)
                            }
                        }
                    }
                    else {
                        self?.activeRequests.remove(webServiceObj)
                        if let task = dataTask {
                            self?.removeTask(task: task)
                        }
                        
                        completion(nil, errData)
                    }
                }
                else {
                    if let competionList = self?.webServiceObjectInfo[webServiceObj.taskID] {
                        let list = competionList as NSArray
                        let finalList = list.copy() as? [NetworkServiceHandler]
                        
                        self?.webServiceObjectInfo.removeValue(forKey: webServiceObj.taskID)
                        self?.activeRequests.remove(webServiceObj)
                        if let task = dataTask {
                            self?.removeTask(task: task)
                        }
                        
                        completion(jsonObject, nil)
                        if let handlerList = finalList {
                            for handler in handlerList {
                                handler.completionBlock(jsonObject, nil)
                            }
                        }
                    }
                    else {
                        self?.activeRequests.remove(webServiceObj)
                        if let task = dataTask {
                            self?.removeTask(task: task)
                        }
                        
                        completion(jsonObject, nil)
                    }
                }
                
            } catch let myJSONError {
                
                let error = DataError()
                print(myJSONError)
                
                if let competionList = self?.webServiceObjectInfo[webServiceObj.taskID] {
                    
                    let list = competionList as NSArray
                    let finalList = list.copy() as? [NetworkServiceHandler]
                    
                    self?.webServiceObjectInfo.removeValue(forKey: webServiceObj.taskID)
                    self?.activeRequests.remove(webServiceObj)
                    if let task = dataTask {
                        self?.removeTask(task: task)
                    }
                    
                    completion(nil, error)
                    if let handlerList = finalList {
                        for handler in handlerList {
                            handler.completionBlock(nil, error)
                        }
                    }
                }
                else {
                    self?.activeRequests.remove(webServiceObj)
                    if let task = dataTask {
                        self?.removeTask(task: task)
                    }
                    
                    completion(nil, error)
                }
            }
        }
        
        let failureBlock = { [weak self] (dataTask: URLSessionDataTask?, error : CustomErrorProtocol?) in
            
            guard let dataError = error else {
                let error = DataError()
                
                if let competionList = self?.webServiceObjectInfo[webServiceObj.taskID] {
                    
                    let list = competionList as NSArray
                    let finalList = list.copy() as? [NetworkServiceHandler]
                    
                    self?.webServiceObjectInfo.removeValue(forKey: webServiceObj.taskID)
                    self?.activeRequests.remove(webServiceObj)
                    if let task = dataTask {
                        self?.removeTask(task: task)
                    }
                    
                    completion(nil, error)
                    if let handlerList = finalList {
                        for handler in handlerList {
                            handler.completionBlock(nil, error)
                        }
                    }
                }
                else {
                    self?.activeRequests.remove(webServiceObj)
                    if let task = dataTask {
                        self?.removeTask(task: task)
                    }
                    
                    completion(nil, error)
                }
                return
            }
            
            let error = DataError(withError: dataError)
            
            if let competionList = self?.webServiceObjectInfo[webServiceObj.taskID] {
                
                let list = competionList as NSArray
                let finalList = list.copy() as? [NetworkServiceHandler]
                
                self?.webServiceObjectInfo.removeValue(forKey: webServiceObj.taskID)
                self?.activeRequests.remove(webServiceObj)
                if let task = dataTask {
                    self?.removeTask(task: task)
                }
                
                completion(nil, error)
                if let handlerList = finalList {
                    for handler in handlerList {
                        handler.completionBlock(nil, error)
                    }
                }
            }
            else {
                self?.activeRequests.remove(webServiceObj)
                if let task = dataTask {
                    self?.removeTask(task: task)
                }
                
                completion(nil, error)
            }
        }
        
        if let dataTask = self.getRequest(withURLStr: path, requestType: type, param: param, headers: headers, successHander: successBlock, failureHandler: failureBlock) {
            addTask(task: dataTask)
        }
    }
    
    private func getRequest(withURLStr urlStr : String, requestType type: RequestType, param paramVal: [AnyHashable : Any]?, headers headerVal: [String : String]?, successHander successBlock: ((URLSessionDataTask?, Any?) -> Void)?, failureHandler failureBlock: ((URLSessionDataTask?, CustomErrorProtocol?) -> Void)?) -> URLSessionDataTask? {
        let dataTaskVal = dataTask(withURLStr: urlStr, requestType: type, param: paramVal, headers: headerVal, successHander: successBlock, failureHandler: failureBlock)
        dataTaskVal?.resume()
        return dataTaskVal
    }
    
    private func addTask(task : URLSessionTask) {
        if !taskList.contains(task) {
            taskList.append(task)
            incrementActivityCount()
        }
    }
    
    private func removeTask(task : URLSessionTask) {
        if taskList.contains(task) {
            taskList = taskList.filter { $0 != task }
            decrementActivityCount()
        }
    }
    
    private func decrementActivityCount() {
        activityCounter -= 1
        if activityCounter < 0 {
            activityCounter = 0
        }
        updateNetworkActibityIndicator()
    }
    
    private func incrementActivityCount() {
        activityCounter += 1
        updateNetworkActibityIndicator()
    }
    
    private func updateNetworkActibityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = (activityCounter > 0)
    }
    
    private static func urlCache() -> URLCache {
        let urlCache = URLCache(memoryCapacity: 20*1024*1024, diskCapacity: 100*1024*1024, diskPath: "com.ContactAppWebRequest.downloader")
        return urlCache
    }
}



extension NetworkServiceManager : NetworkDataDownloaderProtocol {
    
    /**
     This method will be used for creating web request.
     - Parameter path: path is the end point from which we need to load the data from server.
     - Parameter param: param is json we need to give as request param.
     - Parameter headers: headers is the additional headers which are required for URL request.
     - Parameter type: type is the RequestType (i.e. GET, POST, DELETE, PUT etc.).
     - Parameter completion: completion is the callback once data is fetched.
     */
    
    func createDataRequest(withPath path : String, withParam param: [AnyHashable : Any]?, withCustomHeader headers : [String : String]? , withRequestType type : RequestType, withCompletion completion : @escaping (Any?, CustomErrorProtocol?) -> Void)
    {
        self.createRequest(withPath: path, withParam: param, withCustomHeader: headers, withRequestType: type, withCompletion: completion)
    }
    
    func cancelAllTasks() {
        for task in taskList {
            task.cancel()
        }
        taskList.removeAll()
        webServiceObjectInfo.removeAll()
        activeRequests.removeAll()
        activityCounter = 0
        updateNetworkActibityIndicator()
    }
}
