//
//  MoveTextFieldManager.swift
//  MyChat
//
//  Created by Administrator on 12.04.2021.
//

import UIKit

// MARK: - MoveTextFieldManager

class MoveTextFieldManager: MoveTextFieldProtocol {
    
    // MARK: - Private properties
    
    private let view: UIView
    
    private var keyboardHeight: CGFloat = 0
    
    // MARK: - Initialization
    
    init(view: UIView) {
        self.view = view
    }
    
    // MARK: - Public methods
    
    @objc func keyboardWillShow(notification: Notification) {

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue

            if keyboardHeight != keyboardRectangle.height {
                keyboardHeight = keyboardRectangle.height
                moveTextField(moveDistance: keyboardHeight, moveUp: false)
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {

        moveTextField(moveDistance: keyboardHeight, moveUp: true)
        keyboardHeight = 0
    }
    
    // MARK: - Private methods

    private func moveTextField(moveDistance: CGFloat, moveUp: Bool) {

        let movement: CGFloat = CGFloat(moveUp ? moveDistance: -moveDistance)

        UIView.animate(withDuration: 0.3) {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        }
    }
}
