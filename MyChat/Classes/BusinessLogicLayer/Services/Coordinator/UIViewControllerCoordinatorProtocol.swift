//
//  UIViewControllerCoordinatorProtocol.swift
//  MyChat
//
//  Created by Administrator on 22.04.2021.
//

import UIKit

// MARK: - UIViewControllerCoordinatorProtocol

protocol UIViewControllerCoordinatorProtocol: UIViewController {
    var coordinator: GoToCoordinatorProtocol? { get set }
}
