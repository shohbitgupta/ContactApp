//
//  ViewAccessorProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation

/**
 This Generic Protocol is to provide requirements for making any type as View Model to Interact with View in MVVM Design Pattern.
 */

protocol TableViewAccessor {
    associatedtype Item
    func numberOfSections() -> Int
    func numberOfRows(section : Int) -> Int
    subscript (index : IndexPath) -> Item? {get}
}

protocol TableViewOptionalAccessor {
    func title(forSection section : Int) -> String?
}
