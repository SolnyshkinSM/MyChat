//
//  CoordinatorProtocol.swift
//  MyChat
//
//  Created by Administrator on 09.04.2021.
//

import UIKit

// MARK: - CoordinatorProtocol

protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get }
    func start()
}
