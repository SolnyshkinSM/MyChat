//
//  NetworkService.swift
//  MyChat
//
//  Created by Administrator on 18.04.2021.
//

import Foundation

// MARK: - NetworkService

class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Private properties
    
    private let dataTaskStack: DataTaskStackProtocol = DataTaskStack()
    
    // MARK: - Public methods
    
    func request(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = dataTaskStack.createDataTask(from: request, completion: completion)
        task.resume()
    }
}
