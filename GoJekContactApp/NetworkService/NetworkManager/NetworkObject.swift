//
//  NetworkObject.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation


/**
 This Type is used for tracking webservice made to server.
 */

class NetworkObject : NSObject, NetworkObjectProtocol {
    
    let taskID : String
    private(set) var handlerList : [NetworkServiceHandler] = []
    
    required init(taskID identifier : String, withParam param : [AnyHashable : Any]?) {
        if let paramVal = param as? [String : Any] {
            let key = NetworkObject.createString(fromDictionary: paramVal)
            taskID = identifier + key
        }
        else {
            taskID = identifier
        }
    }
    
    private static func createString(fromDictionary dict: [String : Any]?) -> String {
        if let json = dict {
            let array = json.keys
            let sortedList = array.sorted()
            
            var string = ""
            for key in sortedList {
                if let val = json[key] as? String {
                    string = string.appendingFormat("-%@:%@", key, val)
                }
                else if let val = json[key] as? Double {
                    string = string.appendingFormat("-%@:%@", key, val)
                }
                else if let val = json[key] as? Float {
                    string = string.appendingFormat("-%@:%@", key, val)
                }
                else if let val = json[key] as? Int64 {
                    string = string.appendingFormat("-%@:%@", key, val)
                }
                else if let val = json[key] as? [String : Any] {
                    string = createString(fromDictionary: val)
                }
            }
            return string
        }
        return ""
    }
}
