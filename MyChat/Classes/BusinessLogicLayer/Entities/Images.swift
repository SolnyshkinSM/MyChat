//
//  Images.swift
//  MyChat
//
//  Created by Administrator on 18.04.2021.
//

import Foundation

// MARK: - ImagesGroup

struct ImagesGroup: Decodable {
    let total: Int?
    let totalHits: Int?
    let hits: [Image]?
}

// MARK: - Image

struct Image: Decodable {
    let uuid: Int?
    let previewURL: String?
    let largeImageURL: String?

    enum CodingKeys: String, CodingKey {
      case uuid = "id", previewURL, largeImageURL
    }
}
