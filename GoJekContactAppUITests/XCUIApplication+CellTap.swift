//
//  XCUIApplication+CellTap.swift
//  ContactAppUITests
//
//  Created by B0095764 on 1/31/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import XCTest

extension XCUIApplication {
    var isDisplayingHomePage: Bool {
        return otherElements["contactHomePage"].exists
    }
    
    var isDisplayingDetailPage: Bool {
        return otherElements["contactDetailPage"].exists
    }
    
    var isDisplayingEditPage: Bool {
        return otherElements["contactEditPage"].exists
    }
    
    var isDisplayingAddPage: Bool {
        return otherElements["contactAddPage"].exists
    }
}
