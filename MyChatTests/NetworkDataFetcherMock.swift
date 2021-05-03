//
//  NetworkDataFetcherMock.swift
//  MyChatTests
//
//  Created by Administrator on 03.05.2021.
//

@testable import MyChat
import Foundation

class NetworkDataFetcherMock: NetworkDataFetcherProtocol {
    
    let networking: NetworkServiceProtocol
    let decodeStack: DecodeStackProtocol
   
    init(networking: NetworkServiceProtocol = NetworkService(),
         decodeStack: DecodeStackProtocol = DecodeStack()) {
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
