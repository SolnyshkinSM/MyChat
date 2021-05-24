//
//  Coordinator.swift
//  MyChat
//
//  Created by Administrator on 09.04.2021.
//

import UIKit
import CoreData

// MARK: - Coordinator

/**
 Coordinator pattern
 */

final class Coordinator: CoordinatorProtocol {

    // MARK: - Private properties

    private var navigationController: UINavigationController

    private let storyboard = UIStoryboard(name: "Main", bundle: nil)

    private let animatorPresen = AnimatorPresent()

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

extension Coordinator: GoToCoordinatorProtocol {

    // MARK: - Public methods

    func goToChannelDetailViewController(coreDataStack: CoreDataStackProtocol, channel: NSManagedObject) {

        if let viewController = storyboard.instantiateViewController(
            withIdentifier: "ConversationViewController") as? ConversationViewController,
           let channel = channel as? Channel {
            viewController.coreDataStack = coreDataStack
            viewController.configure(with: channel)
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    func goToProfileViewController() {

        if let controller = storyboard.instantiateViewController(
            withIdentifier: "ProfileViewController") as? ProfileViewController {
            controller.coordinator = self
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = animatorPresen
            navigationController.present(controller, animated: true)
        }
    }

    func goToThemesViewController() {

        if let controller = storyboard.instantiateViewController(
            withIdentifier: "ThemesViewController") as? ThemesViewController {
            navigationController.pushViewController(controller, animated: true)
        }
    }

    func goToSelectImagesViewController(delegate: SelectImagesDelegateProtocol?) {

        if let controller = storyboard.instantiateViewController(
            withIdentifier: "SelectImagesViewController") as? SelectImagesViewController {
            controller.delegate = delegate
            navigationController.showDetailViewController(controller, sender: nil)
        }
    }
}
