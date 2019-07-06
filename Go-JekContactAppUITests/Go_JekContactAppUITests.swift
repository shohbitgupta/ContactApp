//
//  Go_JekContactAppUITests.swift
//  Go-JekContactAppUITests
//
//  Created by B0203470 on 04/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import XCTest
var app: XCUIApplication!

class Go_JekContactAppUITests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        super.setUp()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        // We send a command line argument to our app, to enable it to reset its state
        app.launchArguments.append("--uitesting")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
        app = nil
        super.tearDown()
    }
    
    func testFullFlow() {
        app.launch()
        
        let myTable = app.tables.matching(identifier: "homeTableId")
        let cell = myTable.cells.element(matching: .cell, identifier: "homeCell_0_0")
        cell.tap()
        
        app.buttons["call_button"].tap()
        app.buttons["message_button"].tap()
        app.buttons["email_button"].tap()
        app.buttons["fav_button"].tap()
        app.buttons["edit"].tap()
        
        app.buttons["camera_button"].tap()
        
        let textList = ["Nishit", "Sharma", "9650731973", "asc@gmail.com"]
        for index in 0..<textList.count {
            let val = textList[index]
            let textField = app.textFields["editCellTextField_\(index)"]
            textField.clearAndEnterText(text: val)
        }
        
        app.buttons["done"].tap()
        
        app.buttons["add"].tap()
        
        app.buttons["camera_button"].tap()
        
        let addTextList = ["Nishit", "Sharma", "9650731973", "asc@gmail.com"]
        for index in 0..<addTextList.count {
            let val = addTextList[index]
            let textField = app.textFields["editCellTextField_\(index)"]
            textField.clearAndEnterText(text: val)
        }
        
        app.buttons["done"].tap()
    }
}
