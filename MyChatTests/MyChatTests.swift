//
//  MyChatTests.swift
//  MyChatTests
//
//  Created by Administrator on 03.05.2021.
//

@testable import MyChat
import XCTest

class MyChatTests: XCTestCase {

    var dataTaskStack: DataTaskStackProtocol?
    var networking: NetworkServiceProtocol?
    var decodeStack: DecodeStackProtocol?
    var networkDataFetcher: NetworkDataFetcherProtocol?
    var dataFetcherService: DataFetcherServiceProtocol?

    override func setUpWithError() throws {

        dataTaskStack = DataTaskStackMock()

        guard let dataTaskStack = dataTaskStack else { return }

        networking = NetworkServiceMock(dataTaskStack: dataTaskStack)
        decodeStack = DecodeStackMock()

        guard let networking = networking,
              let decodeStack = decodeStack else { return }

        networkDataFetcher = NetworkDataFetcherMock(networking: networking, decodeStack: decodeStack)

        guard let networkDataFetcher = networkDataFetcher else { return }
        dataFetcherService = DataFetcherServiceMock(networkDataFetcher: networkDataFetcher)

        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        dataTaskStack = nil
        networking = nil
        decodeStack = nil
        networkDataFetcher = nil
        dataFetcherService = nil
        try super.tearDownWithError()
    }

    func testDataFetcherService() throws {

        // Arrage
        var images: [Image]?
        let dataFetcherExpectation = expectation(description: #function)

        // Act
        dataFetcherService?.fetchImages { imagesGroup in
            images = imagesGroup?.hits
            dataFetcherExpectation.fulfill()
        }

        // Assert
        waitForExpectations(timeout: 2.0) { error in
            if let error = error { XCTFail(error.localizedDescription) }
            XCTAssertNotNil(images)
            XCTAssertEqual(images?.count, 1)
        }
    }

    func testNetworkDataFetcher() throws {

        // Arrage
        var images: [Image]?
        let urlImages = API.urlLoadImages + "?key=\(API.keyLoadImages)&q=portrait&per_page=150"
        let networkDataFetcherExpectation = expectation(description: #function)

        // Act
        networkDataFetcher?.fetchGenericJSONData(urlString: urlImages) { (imagesGroup: ImagesGroup?) in
            images = imagesGroup?.hits
            networkDataFetcherExpectation.fulfill()
        }

        // Assert
        waitForExpectations(timeout: 2.0) { error in
            if let error = error { XCTFail(error.localizedDescription) }
            XCTAssertNotNil(images)
            XCTAssertEqual(images?.count, 1)
        }
    }

    func testDecodeStack() throws {

        // Arrage
        let data = Data("""
                {
                  "total": 1,
                  "totalHits": 1,
                  "hits":[
                            {"id": 1000100, "previewURL": "https://tinkoff.ru"},
                            {"id": 1000200, "previewURL": "https://tinkoffTwo.ru"}
                        ]
                }
                """.utf8)

        // Act
        let imagesGroup = decodeStack?.decodeJSON(type: ImagesGroup.self, from: data)

        // Assert
        XCTAssertNotNil(imagesGroup)
        XCTAssertEqual(imagesGroup?.hits?.count, 2)
    }

    func testDataTaskStack() throws {

        // Arrage
        typealias Type = ImagesGroup

        var images: [Image]?
        let dataTaskStackExpectation = expectation(description: #function)
        let urlImages = API.urlLoadImages + "?key=\(API.keyLoadImages)&q=portrait&per_page=150"

        guard let url = URL(string: urlImages) else {
            XCTFail("Bad URL")
            return
        }

        let request = URLRequest(url: url)
        let response: (Type?) -> Void = { imagesGroup in
            images = imagesGroup?.hits
            dataTaskStackExpectation.fulfill()
        }

        let completion: (Data?, Error?) -> Void = { (data, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
                response(nil)
            }
            let decoded = self.decodeStack?.decodeJSON(type: Type.self, from: data)
            response(decoded)
        }

        // Act
        if let task = dataTaskStack?.createDataTask(from: request, completion: completion) { task.resume() }

        // Assert
        waitForExpectations(timeout: 10.0) { error in
            if let error = error { XCTFail(error.localizedDescription) }
            XCTAssertNotNil(images)
            XCTAssertEqual(images?.count, 1)
        }
    }
}
