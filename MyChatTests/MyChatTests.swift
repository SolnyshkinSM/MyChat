//
//  MyChatTests.swift
//  MyChatTests
//
//  Created by Administrator on 02.05.2021.
//

@testable import MyChat
import XCTest

class MyChatTests: XCTestCase {

    var dataFetcherServiceMock: DataFetcherServiceProtocol?
    
    override func setUpWithError() throws {
        dataFetcherServiceMock = DataFetcherServiceMock()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        dataFetcherServiceMock = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        
        XCTAssertTrue(false)
        
        /*// Arrage
        var images = [Image]()
        let dataFetcherexpectation = expectation(description: #function)
        
        // Act
        dataFetcherServiceMock?.fetchImages { imagesGroup in
            guard let hits = imagesGroup?.hits else { return }
            images = hits
            dataFetcherexpectation.fulfill()
        }
        
        // Assert
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertTrue(false)
        }*/
        
    }
    
    func testLaunchPerformance() throws {
        measure {
        }
    }
}
