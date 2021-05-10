//
//  DataFetcherServiceMock.swift
//  MyChatTests
//
//  Created by Administrator on 03.05.2021.
//

@testable import MyChat
import Foundation

class DataFetcherServiceMock: DataFetcherServiceProtocol {

    private var networkDataFetcher: NetworkDataFetcherProtocol

    init(networkDataFetcher: NetworkDataFetcherProtocol = NetworkDataFetcherMock()) {
        self.networkDataFetcher = networkDataFetcher
    }

    func fetchImages(completion: @escaping (ImagesGroup?) -> Void) {
        let urlImages = API.urlLoadImages + "?key=\(API.keyLoadImages)&q=portrait&per_page=150"
        networkDataFetcher.fetchGenericJSONData(urlString: urlImages, response: completion)
    }
}
