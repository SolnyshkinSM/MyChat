//
//  ImageLoader.swift
//  MyChat
//
//  Created by Administrator on 22.04.2021.
//

import UIKit

// MARK: - ImageLoader

class ImageLoader: ImageLoaderProtocol {
    
    // MARK: - Private properties
    
    private var uploadedImages = [URL: UIImage]()
    private var runningQueries = [UUID: URLSessionDataTask]()
    
    // MARK: - Public methods
    
    func uploadImage(by url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        if let image = uploadedImages[url] {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            
            defer { self?.runningQueries.removeValue(forKey: uuid) }
            
            if let data = data, let image = UIImage(data: data) {
                self?.uploadedImages[url] = image
                completion(.success(image))
                return
            }
            
            guard let error = error else { return }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
        }
        
        runningQueries[uuid] = task
        
        task.resume()
        
        return uuid
    }
    
    func cancelRunningQueries(for uuid: UUID) {
        runningQueries[uuid]?.cancel()
        runningQueries.removeValue(forKey: uuid)
    }
}
