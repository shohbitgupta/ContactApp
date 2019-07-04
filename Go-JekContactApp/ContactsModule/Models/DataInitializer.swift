//
//  DataInitializer.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//
import Foundation

/**
 This Protocol is to provide requirements for initializing any application model object.
 */

protocol DataInitializer {
    init(withData data : [AnyHashable : Any])
}
