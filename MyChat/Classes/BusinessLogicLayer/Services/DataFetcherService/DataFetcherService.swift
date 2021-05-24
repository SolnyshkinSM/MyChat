//
//  DataFetcherService.swift
//  MyChat
//
//  Created by Administrator on 18.04.2021.
//

import Foundation

// MARK: - DataFetcherService

class DataFetcherService: DataFetcherServiceProtocol {
    
    // MARK: - Private properties
    
    private var networkDataFetcher: NetworkDataFetcherProtocol
    
    // MARK: - Initialization
    
    init(networkDataFetcher: NetworkDataFetcherProtocol = NetworkDataFetcher()) {
        self.networkDataFetcher = networkDataFetcher
    }
    
    // MARK: - Public methods
    
    func fetchImages(completion: @escaping (ImagesGroup?) -> Void) {
        let apiKey = "21218574-f0d32fe5e463e87432665c8e4"
        let urlImages = "https://pixabay.com/api/?key=\(apiKey)&q=portrait&per_page=150"
        networkDataFetcher.fetchGenericJSONData(urlString: urlImages, response: completion)
    }
}
