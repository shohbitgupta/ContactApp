//
//  XCUIApplicationCellTap.swift
//  GoJekContactAppUITests
//
//  Created by B0203470 on 07/07/19.
//  Copyright © 2019 BSB. All rights reserved.
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

extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            return
        }
        
        self.tap()
        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        self.typeText(deleteString)
        self.typeText(text)
    }
}
