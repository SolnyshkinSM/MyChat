//
//  DecodeStackMock.swift
//  MyChatTests
//
//  Created by Administrator on 04.05.2021.
//

@testable import MyChat
import Foundation

class DecodeStackMock: DecodeStackProtocol {
    
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
