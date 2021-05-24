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
        let urlImages = API.urlLoadImages + "?key=\(API.keyLoadImages)&q=portrait&per_page=150"
        networkDataFetcher.fetchGenericJSONData(urlString: urlImages, response: completion)
    }
}
