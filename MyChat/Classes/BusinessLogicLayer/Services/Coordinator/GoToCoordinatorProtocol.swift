//
//  GoToCoordinatorProtocol.swift
//  MyChat
//
//  Created by Administrator on 09.04.2021.
//

import UIKit
import CoreData

// MARK: - GoToCoordinatorProtocol

protocol GoToCoordinatorProtocol {
    func goToChannelDetailViewController(coreDataStack: CoreDataStackProtocol, channel: NSManagedObject)
    func goToProfileViewController()
    func goToThemesViewController()
    func goToSelectImagesViewController(delegate: SelectImagesDelegateProtocol?)
}
