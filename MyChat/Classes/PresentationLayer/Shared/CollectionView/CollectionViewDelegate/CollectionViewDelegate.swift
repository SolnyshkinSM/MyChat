//
//  UICollectionViewDelegate.swift
//  MyChat
//
//  Created by Administrator on 22.04.2021.
//

import UIKit

// MARK: - UICollectionViewDelegate

class CollectionViewDelegate: NSObject, CollectionViewDelegateProtocol {
    
    // MARK: - Private properties
    
    private var delegate: UIViewControllerCollectionViewDataSourceProtocol
    
    var selectImagesDelegate: SelectImagesDelegateProtocol?
    
    private let loader: ImageLoaderProtocol
    
    // MARK: - Initialization
    
    init(delegate: UIViewControllerCollectionViewDataSourceProtocol,
         selectImagesDelegate: SelectImagesDelegateProtocol?,
         loader: ImageLoaderProtocol) {
        self.delegate = delegate
        self.selectImagesDelegate = selectImagesDelegate
        self.loader = loader
    }
    
    // MARK: - Public methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let object = delegate.images?[indexPath.row],
              let selectImagesDelegate = selectImagesDelegate,
              let previewURL = object.largeImageURL,
              let imageUrl = URL(string: previewURL) else { return }
        
        _ = loader.uploadImage(by: imageUrl) { result in
            do {
                let image = try result.get()
                DispatchQueue.main.async { selectImagesDelegate.imagePickerHandler(image: image) }
            } catch {
                print(error)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.3, height: collectionView.bounds.width * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
