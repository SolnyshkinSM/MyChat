//
//  MoveTextFieldManagerDelegate.swift
//  MyChat
//
//  Created by Administrator on 12.04.2021.
//

import Foundation

// MARK: - MoveTextFieldManagerDelegate

@objc
protocol MoveTextFieldManagerDelegate {
    func keyboardWillShow(notification: Notification)
    func keyboardWillHide(notification: Notification)
}
