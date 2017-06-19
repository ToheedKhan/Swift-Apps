//
//  LocationsUITests.swift
//  LocationsUITests
//
//  Created by Toheed Khan on 07/06/17.
//  Copyright © 2017 Toheed Khan. All rights reserved.
//

import XCTest

class LocationsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
  
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testActionSheetDismissedAfterTappingOnAnySortOption(){
        let app = XCUIApplication()
        app.navigationBars["Locations"].buttons["Sort"].tap()
        XCUIDevice.shared().orientation = .faceUp
        XCUIDevice.shared().orientation = .faceUp
    
        app.sheets["Sort by"].buttons["Sort by distance"].tap()
        XCTAssertEqual(app.sheets.element.exists, false)
    }
    
    func testLocationDetailVCRemovedAfterTappingLocationsBack(){
        // Use recording to get started writing UI tests.
        XCUIDevice.shared().orientation = .faceUp
        XCUIDevice.shared().orientation = .faceUp
        
        let app = XCUIApplication()
        let tableView = app.tables.containing(.table, identifier: "LocationsTable")
        XCTAssertEqual(tableView.element.exists, true)
        sleep(5)
        
        let tableCell = tableView.cells.allElementsBoundByAccessibilityElement[0]

        tableCell.tap()

        //        let existsPredicate = NSPredicate(format: "exists == 1")
        //        expectation(for: existsPredicate, evaluatedWith: tableCell.exists, handler: nil)
        //
        //
        //        waitForExpectations(timeout: 15, handler: nil)
        //        let firstCell = tableView.cells.element(boundBy: 0)
        //        firstCell.tap()
        //        app.navigationBars["LocationDetail"].buttons["Locations"].tap()
        //
        //        XCTAssertEqual(app.navigationBars["LocationDetail"].exists, false)
        
        //        app.tables["LocationsTable"].cells["Frontera Grill, 445 N Clark St, Chicago, IL 60654"].tap()
        XCTAssertEqual(app.navigationBars.buttons.element(boundBy: 1).exists, true);

        app.navigationBars["LocationDetail"].buttons["Locations"].tap()
        //        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertEqual(app.navigationBars.buttons.element(boundBy: 1).exists, false);
//        XCTAssertEqual(app.navigationBars[tableCell.title].exists, false)
        
    }
    
    func waitForElementToAppear(_ element: XCUIElement, file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: 10) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after 10 seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
}
