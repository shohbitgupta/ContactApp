//
//  URLSessionManager.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation


/**
 This Type is used for fetching, uploading data from or to any API from the server.
 */

class URLSessionManager {
    
    private let urlSession : URLSession
    private let hostURL : URL?
    
    init(withConfiguration config : URLSessionConfiguration, withBaseURL url : URL?) {
        hostURL = url
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        urlSession = URLSession(configuration: config, delegate: nil, delegateQueue: opQueue)
    }
    
    init(withBaseUrl baseURL : URL?) {
        hostURL = baseURL
        let sessionConfig = URLSessionConfiguration.default
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        urlSession = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: opQueue)
    }
    
    static func defaultURLSessionManager() -> URLSessionManager {
        return URLSessionManager(withBaseUrl: nil)
    }
    
    static func sessionManager(withConfiguration sessionConfig : URLSessionConfiguration, withBaseURL url : URL?) -> URLSessionManager {
        return URLSessionManager(withConfiguration: sessionConfig, withBaseURL: url)
    }
    
    static func sessionManager(withBaseURL url : URL?) -> URLSessionManager {
        return URLSessionManager(withBaseUrl: url)
    }
}

extension URLSessionManager : URLSessionManagerProtocol {
    
    @discardableResult
    func dataTask(withURLStr urlStr : String, requestType type: RequestType, param paramVal: [AnyHashable : Any]?, headers headerVal: [String : String]?, successHander successBlock: ((URLSessionDataTask?, Any?) -> Void)?, failureHandler failureBlock: ((URLSessionDataTask?, CustomErrorProtocol?) -> Void)?) -> URLSessionDataTask? {
        
        guard let urlReq = URL(string: urlStr, relativeTo: self.hostURL) else {
            if let failure = failureBlock {
                failure(nil, DataError())
            }
            return nil
        }
        
        var request = URLRequest(url: urlReq)
        request.httpMethod = requestMethod(withRequestType: type)
        if let customHeader = headerVal {
            for (key, value) in customHeader {
                if let _ = request.value(forHTTPHeaderField: key) {
                }
                else {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
        }
        
        if let paramData = paramVal {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: paramData, options: JSONSerialization.WritingOptions(rawValue: 0))
            } catch let myJSONError {
                print(myJSONError)
                return nil
            }
        }
        
        var task : URLSessionDataTask?
        task = dataTask(withRequest: request) { (response, data, error) in
            if let dataError = error {
                if let failure = failureBlock {
                    failure(task, dataError)
                }
            }
            else {
                if let success = successBlock {
                    success(task, data)
                }
            }
        }
        
        return task
    }
    
    @discardableResult
    func dataTask(withRequest reuest : URLRequest, withCompletion completion : ((URLResponse?, Any?, CustomErrorProtocol?) -> Void)?) -> URLSessionDataTask {
        let dataTask = urlSession.dataTask(with: reuest) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let handler = completion {
                    if let err = error {
                        let customErr : CustomErrorProtocol = DataError(withError: err)
                        handler(response, data, customErr)
                    }
                    else {
                        handler(response, data, nil)
                    }
                }
            }
        }
        return dataTask
    }
}

// Private Method Extension

extension URLSessionManager {
    
    private func requestMethod(withRequestType type : RequestType) -> String {
        return type.rawValue
    }
}
