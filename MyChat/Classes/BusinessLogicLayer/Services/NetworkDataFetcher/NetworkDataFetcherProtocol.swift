//
//  NetworkDataFetcherProtocol.swift
//  MyChat
//
//  Created by Administrator on 18.04.2021.
//

import Foundation

// MARK: - NetworkDataFetcherProtocol

protocol NetworkDataFetcherProtocol {
    func fetchGenericJSONData<T: Decodable>(urlString: String, response: @escaping (T?) -> Void)
}
