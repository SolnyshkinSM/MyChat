//
//  UIAlertController.swift
//  MyChat
//
//  Created by Administrator on 08.03.2021.
//

import UIKit

// MARK: - UIAlertController

extension UIAlertController {

    convenience init(title: String? = nil, message: String? = nil, okHandler: ((UIAlertAction) -> Void)? = nil) {

        self.init(title: title, message: message, preferredStyle: .alert)

        let okButton = UIAlertAction(title: "Ok", style: .default, handler: okHandler)
        addAction(okButton)
        setBackgroundColor(color: ThemeManager.shared.currentTheme.buttonBackgroundColor)
    }

    func setBackgroundColor(color: UIColor) {

        self.view.subviews.first?.subviews.first?.subviews.forEach { view in
            view.backgroundColor = color
        }
    }
}
