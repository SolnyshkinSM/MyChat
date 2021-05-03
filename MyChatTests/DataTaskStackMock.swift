//
//  DataTaskStackMock.swift
//  MyChatTests
//
//  Created by Administrator on 03.05.2021.
//

@testable import MyChat
import Foundation

// MARK: - DataTaskStackMock

class DataTaskStackMock: DataTaskStackProtocol {
    
    func createDataTask(from requst: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: requst, completionHandler: { (data, _, error) in
            
            // TODO: sleep
            sleep(1)
            
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
}
