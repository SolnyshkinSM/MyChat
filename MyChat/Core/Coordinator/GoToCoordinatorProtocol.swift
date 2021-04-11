//
//  GoToCoordinatorProtocol.swift
//  MyChat
//
//  Created by Administrator on 09.04.2021.
//

import Foundation

// MARK: - GoToCoordinatorProtocol

protocol GoToCoordinatorProtocol {
    func goToChannelDetailViewController(coreDataStack: CoreDataStackProtocol, channel: Channel)
    func goToProfileViewController()
    func goToThemesViewController()
}
