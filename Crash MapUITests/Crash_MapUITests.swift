//
//  Crash_MapUITests.swift
//  Crash MapUITests
//
//  Created by Pavel Holec on 26/02/2020.
//  Copyright © 2020 com.ph. All rights reserved.
//

import XCTest

class Crash_MapUITests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testNavigationToDetailAndBack() {
        let app = XCUIApplication()
        app.launch()
        let meteoriteToTest = "Chelyabinsk"
        app.cells[meteoriteToTest].tap()
    }
}
