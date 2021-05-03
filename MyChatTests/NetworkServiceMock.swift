//
//  NetworkServiceMock.swift
//  MyChatTests
//
//  Created by Administrator on 03.05.2021.
//

@testable import MyChat
import Foundation

// MARK: - NetworkServiceMock

class NetworkServiceMock: NetworkServiceProtocol {
    
    func request(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        
    }  
}
