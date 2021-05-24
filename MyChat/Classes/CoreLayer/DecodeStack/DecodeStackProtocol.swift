//
//  DecodeStackProtocol.swift
//  MyChat
//
//  Created by Administrator on 03.05.2021.
//

import Foundation

// MARK: - DecodeStackProtocol

protocol DecodeStackProtocol {
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T?
}
