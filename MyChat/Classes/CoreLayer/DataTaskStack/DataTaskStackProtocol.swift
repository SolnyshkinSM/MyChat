//
//  DataTaskStackProtocol.swift
//  MyChat
//
//  Created by Administrator on 03.05.2021.
//

import Foundation

// MARK: - DataTaskStackProtocol

protocol DataTaskStackProtocol {
    func createDataTask(from requst: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask
}
