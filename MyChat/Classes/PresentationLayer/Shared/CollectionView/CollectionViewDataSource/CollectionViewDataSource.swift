//
//  CollectionViewDataSource.swift
//  MyChat
//
//  Created by Administrator on 22.04.2021.
//

import UIKit

// MARK: - UIViewControllerCollectionViewDataSourceProtocol

protocol UIViewControllerCollectionViewDataSourceProtocol {
    var images: [Image]? { get set }
}

// MARK: - CollectionViewDataSource

class CollectionViewDataSource: NSObject, CollectionViewDataSourceProtocol {

    // MARK: - Private properties

    private weak var delegate: UIViewControllerCollectionViewDataSourceProtocol

    private let loader: ImageLoaderProtocol

    // MARK: - Initialization

    init(delegate: UIViewControllerCollectionViewDataSourceProtocol,
         loader: ImageLoaderProtocol) {
        self.delegate = delegate
        self.loader = loader
    }

    // MARK: - Public methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.images?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SelectImagesViewController.Constants.collectionCellIdentifier,
                for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }

        let object = delegate.images?[indexPath.row]

        guard let previewURL = object?.largeImageURL,
              let imageUrl = URL(string: previewURL) else { return cell }

        let token = loader.uploadImage(by: imageUrl) { result in
            do {
                let image = try result.get()
                DispatchQueue.main.async { cell.configure(with: image) }
            } catch {
                print(error.localizedDescription)
            }
        }

        cell.reuseCellHandler = {
            if let token = token { self.loader.cancelRunningQueries(for: token) }
        }

        return cell
    }
}
