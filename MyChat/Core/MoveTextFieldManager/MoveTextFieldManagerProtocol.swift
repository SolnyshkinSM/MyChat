//
//  MoveTextFieldManagerProtocol.swift
//  MyChat
//
//  Created by Administrator on 12.04.2021.
//

import Foundation

// MARK: - MoveTextFieldManagerDelegate

@objc
protocol MoveTextFieldManagerProtocol {
    func keyboardWillShow(notification: Notification)
    func keyboardWillHide(notification: Notification)
}
