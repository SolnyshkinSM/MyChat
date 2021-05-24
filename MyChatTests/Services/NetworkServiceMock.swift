//
//  NetworkServiceMock.swift
//  MyChatTests
//
//  Created by Administrator on 04.05.2021.
//

@testable import MyChat
import Foundation

class NetworkServiceMock: NetworkServiceProtocol {

    private let dataTaskStack: DataTaskStackProtocol

    init(dataTaskStack: DataTaskStackProtocol = DataTaskStackMock()) {
        self.dataTaskStack = dataTaskStack
    }

    func request(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        guard let task = dataTaskStack.createDataTask(from: request, completion: completion) else { return }
        task.resume()
    }
}
