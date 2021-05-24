//
//  DecodeStack.swift
//  MyChat
//
//  Created by Administrator on 03.05.2021.
//

import Foundation

// MARK: - DecodeStack

class DecodeStack: DecodeStackProtocol {

    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
