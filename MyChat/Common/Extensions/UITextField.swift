//
//  UITextField.swift
//  MyChat
//
//  Created by Administrator on 07.03.2021.
//

import UIKit

// MARK: - UITextField

extension UITextField {
    
    func setPlaceholder(_ text: String) {
        
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.shared.currentTheme.tintColor])
        
        self.subviews.forEach { view in
            view.backgroundColor = .clear
        }        
    }
}
