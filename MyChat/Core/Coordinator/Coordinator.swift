//
//  Coordinator.swift
//  MyChat
//
//  Created by Administrator on 09.04.2021.
//

import UIKit

// MARK: - Coordinator

/**
 Coordinator pattern
 */

final class Coordinator: ICoordinator {
    
    // MARK: - Public properties
    
    var navigationController: UINavigationController
    
    // MARK: - Private properties
    
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public methods
    
    func start() {
        goToChannelViewController()
    }
    
    // MARK: - Private methods
    
    private func goToChannelViewController() {
        
        if let viewController = storyboard.instantiateViewController(
            withIdentifier: "ConversationsListViewController") as? ConversationsListViewController {
            viewController.coordinator = self
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
}

// MARK: - IMoviesCoordinator

extension Coordinator: IChannelsCoordinator {
    
    func goToChannelDetailViewController(coreDataStack: CoreDataStack, channel: Channel) {
        
        if let viewController = storyboard.instantiateViewController(
            withIdentifier: "ConversationViewController") as? ConversationViewController {
            viewController.coreDataStack = coreDataStack
            viewController.configure(with: channel)
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
