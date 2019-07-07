//
//  CellProtocol.swift
//  Go-JekContactApp
//
//  Created by B0203470 on 05/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation

/**
 This Generic Protocol is to provide requirements for updating any UITableView Cell from a particular object of type Item.
 */

protocol ViewUpdateProtocol {
    associatedtype Item
    func updateView(withData data : Item?)
}

protocol HeaderViewUpdateProtocol {
    associatedtype Item
    func updateView(withData data : Item?, status : Bool)
    func toggleButtonsAndLabelVisibleState()
    func initialSetup()
}
