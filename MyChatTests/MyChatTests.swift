//
//  MyChatTests.swift
//  MyChatTests
//
//  Created by Administrator on 03.05.2021.
//

@testable import MyChat
import XCTest

class MyChatTests: XCTestCase {
    
    var dataFetcherService: DataFetcherServiceProtocol?
    
    override func setUpWithError() throws {
        dataFetcherService = DataFetcherServiceMock()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        dataFetcherService = nil
        try super.tearDownWithError()
    }
    
    func testExample() throws {
        
        // Arrage
        var images: [Image]?
        let dataFetcherExpectation = expectation(description: #function)
        
        // Act
        dataFetcherService?.fetchImages { imagesGroup in
            images = imagesGroup?.hits
            dataFetcherExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            if error != nil {
                XCTFail(error?.localizedDescription ?? "")
            }
            XCTAssertNotNil(images)
            XCTAssertEqual(images?.count, 100)
        }
        
        // Assert
        //XCTAssertTrue(true)
        //XCTAssertTrue(false)
    }
}
