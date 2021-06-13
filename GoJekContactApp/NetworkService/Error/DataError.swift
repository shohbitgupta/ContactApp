//
//  DataError.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation

/**
 This Type is used for making custom error object when any API is hit to get the data from the server.
 */

protocol CustomErrorProtocol : Error {
    var errorMessage : String { get set }
}

class DataError : CustomErrorProtocol {
    
    var errorMessage = Constants.defaultErrorMessage
    
    init() {
    }
    
    init(withError error : Error) {
        errorMessage = error.localizedDescription
    }
    
    static func errorObject(withResponse response : Any?) -> CustomErrorProtocol? {
        if let object = response as? [AnyHashable : Any] {
            if let errVal = object["errors"] as? [Any] {
                let errObj = DataError()
                errObj.errorMessage = errVal.first as? String ?? Constants.defaultErrorMessage
                return errObj
            }
        }
        return nil
    }
}
