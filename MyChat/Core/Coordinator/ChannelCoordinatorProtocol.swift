//
//  ChannelCoordinatorProtocol.swift
//  MyChat
//
//  Created by Administrator on 09.04.2021.
//

import Foundation

// MARK: - ChannelCoordinatorProtocol

protocol ChannelCoordinatorProtocol {
    func goToChannelDetailViewController(coreDataStack: CoreDataStack, channel: Channel)
    func goToProfileViewController()
    func goToThemesViewController()
}
