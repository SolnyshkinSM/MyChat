//
//  NetworkServiceMock.swift
//  MyChatTests
//
//  Created by Administrator on 03.05.2021.
//

@testable import MyChat
import Foundation

// MARK: - NetworkServiceMock

class NetworkServiceMock: NetworkServiceProtocol {
    
    private let dataTaskStack: DataTaskStackProtocol = DataTaskStackMock()
    
    func request(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = dataTaskStack.createDataTask(from: request, completion: completion)
        task.resume()
    }
}
