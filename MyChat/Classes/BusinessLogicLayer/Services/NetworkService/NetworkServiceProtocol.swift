//
//  NetworkServiceProtocol.swift
//  MyChat
//
//  Created by Administrator on 18.04.2021.
//

import Foundation

// MARK: - NetworkServiceProtocol

protocol NetworkServiceProtocol {
    func request(urlString: String, completion: @escaping (Data?, Error?) -> Void)
}
