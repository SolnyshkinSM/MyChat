//
//  NetworkDataFetcherMock.swift
//  MyChatTests
//
//  Created by Administrator on 04.05.2021.
//

@testable import MyChat
import Foundation

class NetworkDataFetcherMock: NetworkDataFetcherProtocol {
    
    private let networking: NetworkServiceProtocol
    private let decodeStack: DecodeStackProtocol
    
    init(networking: NetworkServiceProtocol = NetworkServiceMock(),
         decodeStack: DecodeStackProtocol = DecodeStackMock()) {
        self.networking = networking
        self.decodeStack = decodeStack
    }
    
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
