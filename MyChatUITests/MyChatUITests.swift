//
//  MyChatUITests.swift
//  MyChatUITests
//
//  Created by Administrator on 02.05.2021.
//

import XCTest

class MyChatUITests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testExample() throws {
        
        // Arrage
        let app = XCUIApplication()
        app.launch()
        
        // Act
        app.navigationBars["Channels"].buttons["Profile"].tap()
        
        // Assert
        checkExistenceDelayedElement(element: app.textFields["fullName"])
        checkExistenceDelayedElement(element: app.textFields["Detailed information"])        
    }
    
    func checkExistenceDelayedElement(element: XCUIElement) {
        
        let existsPredicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: existsPredicate, object: element)
        wait(for: [expectation], timeout: 5)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
