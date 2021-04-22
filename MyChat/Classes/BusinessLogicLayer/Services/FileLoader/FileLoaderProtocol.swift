//
//  FileLoaderProtocol.swift
//  MyChat
//
//  Created by Administrator on 17.03.2021.
//

import Foundation

// MARK: - StateLoader

enum StateLoader: String {
    case ready, executing, finished, cancelled
    fileprivate var keyPath: String { return "is" + rawValue.capitalized }
}

// MARK: - FileLoaderProtocol

protocol FileLoaderProtocol {
    static var shared: FileLoaderProtocol { get }
    var state: StateLoader { get set }
    func readFile<T: Codable>(completion: @escaping (Result<T, Error>) -> Void)
    func writeFile<T: Codable>(object: T, completion: @escaping (Result<Bool, Error>) -> Void)
    func cancelAllOperations()
}
