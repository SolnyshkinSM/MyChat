//
//  CollectionViewDataSourceProtocol.swift
//  MyChat
//
//  Created by Administrator on 22.04.2021.
//

import UIKit

// MARK: - CollectionViewDataSourceProtocol

protocol CollectionViewDataSourceProtocol: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}
