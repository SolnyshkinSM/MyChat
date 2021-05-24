//
//  NetworkDataFetcher.swift
//  MyChat
//
//  Created by Administrator on 18.04.2021.
//

import Foundation

// MARK: - NetworkDataFetcher

class NetworkDataFetcher: NetworkDataFetcherProtocol {

    // MARK: - Public properties

    let networking: NetworkServiceProtocol
    let decodeStack: DecodeStackProtocol

    // MARK: - Initialization

    init(networking: NetworkServiceProtocol = NetworkService(),
         decodeStack: DecodeStackProtocol = DecodeStack()) {
        self.networking = networking
        self.decodeStack = decodeStack
    }

    // MARK: - Public methods

    func fetchGenericJSONData<T: Decodable>(urlString: String, response: @escaping (T?) -> Void) {
        networking.request(urlString: urlString) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            let decoded = self.decodeStack.decodeJSON(type: T.self, from: data)
            response(decoded)
        }
    }
}
