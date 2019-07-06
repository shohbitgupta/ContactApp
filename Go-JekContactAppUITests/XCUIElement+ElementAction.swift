//
//  XCUIElement+ElementAction.swift
//  ContactAppUITests
//
//  Created by B0095764 on 1/31/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import XCTest
import Foundation

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
