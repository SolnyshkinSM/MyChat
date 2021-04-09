//
//  ICoordinator.swift
//  MyChat
//
//  Created by Administrator on 09.04.2021.
//

import UIKit

// MARK: - ICoordinator

protocol ICoordinator {
    var navigationController: UINavigationController { get }
    func start()
}
