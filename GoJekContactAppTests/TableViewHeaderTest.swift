//
//  TableViewHeaderTest.swift
//  Go-JekContactAppTests
//
//  Created by B0203470 on 07/07/19.
//  Copyright © 2019 BSB. All rights reserved.
//

import Foundation
import UIKit
@testable import GoJekContactApp


class TableHeaderViewUtilityTest: XCTestCase {
    
    var tableView : UITableView!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        tableView = UITableView(frame: CGRect.zero)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        tableView = nil
        super.tearDown()
    }
    
    func testSetTableHeaderView() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        tableView.setTableHeaderView(headerView: UIView())
    }
    
    func testUpdateframe() {
        tableView.setTableHeaderView(headerView: UIView())
        tableView.updateHeaderViewFrame()
    }
    
}
