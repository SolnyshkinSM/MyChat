//
//  GCDFileLoader.swift
//  MyChat
//
//  Created by Administrator on 14.03.2021.
//

import Foundation

// MARK: - GCDFileLoader

class GCDFileLoader: FileLoaderProtocol {

    static var shared: FileLoaderProtocol = GCDFileLoader()

    var state: StateLoader = .ready

    private let queue = DispatchQueue(label: "ru.queue.isolation", attributes: .concurrent)

    func writeFile<T: Codable>(object: T, completion: @escaping (Result<Bool, Error>) -> Void) {

        state = .executing
        queue.async(flags: .barrier) {
            FileWorkManager<T>().write(object: object, loader: self) { result in
                DispatchQueue.main.async { completion(result) }
            }
        }
    }

    func readFile<T: Codable>(completion: @escaping (Result<T, Error>) -> Void) {

        state = .executing
        queue.async {
            FileWorkManager<T>().read { result in
                DispatchQueue.main.async { completion(result) }
            }
        }
    }

    func cancelAllOperations() {

        state = .cancelled
    }
}
