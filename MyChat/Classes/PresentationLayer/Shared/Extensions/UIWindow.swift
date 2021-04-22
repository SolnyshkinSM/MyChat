//
//  UIWindow.swift
//  MyChat
//
//  Created by Administrator on 08.03.2021.
//

import UIKit

// MARK: - UIWindow

extension UIWindow {

    func reload() {

        subviews.forEach { view in
            view.removeFromSuperview()
            addSubview(view)
        }
    }
}
