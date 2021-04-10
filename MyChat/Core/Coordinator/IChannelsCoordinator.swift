//
//  IChannelsCoordinator.swift
//  MyChat
//
//  Created by Administrator on 09.04.2021.
//

import Foundation

// MARK: - IChannelsCoordinator

protocol IChannelsCoordinator {
    func goToChannelDetailViewController(coreDataStack: CoreDataStack, channel: Channel)
    func goToProfileViewController()
    func goToThemesViewController()
}
