//
//  DataFetcherServiceProtocol.swift
//  MyChat
//
//  Created by Administrator on 03.05.2021.
//

import Foundation

// MARK: - DataFetcherServiceProtocol

protocol DataFetcherServiceProtocol {
    func fetchImages(completion: @escaping (ImagesGroup?) -> Void)
}
