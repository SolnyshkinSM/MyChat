//
//  ImageLoaderProtocol.swift
//  MyChat
//
//  Created by Administrator on 22.04.2021.
//

import UIKit

// MARK: - ImageLoaderProtocol

protocol ImageLoaderProtocol {
    func uploadImage(for: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID?
    func cancelRunningQueries(for: UUID)
}
