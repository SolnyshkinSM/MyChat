//
//  DataTaskStackMock.swift
//  MyChatTests
//
//  Created by Administrator on 04.05.2021.
//

@testable import MyChat
import Foundation

class DataTaskStackMock: DataTaskStackProtocol {

    func createDataTask(from requst: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask? {

        sleep(1)

        let data = Data("""
                {
                  "total": 1,
                  "totalHits": 1,
                  "hits":[ {"id": 1000100, "previewURL": "https://tinkoff.ru"} ]
                }
                """.utf8)

        completion(data, nil)
        return nil
    }
}
