//
//  UIAlertController.swift
//  MyChat
//
//  Created by Administrator on 08.03.2021.
//

import UIKit

// MARK: - UIAlertController

extension UIAlertController {
    
    func setBackgroundColor(color: UIColor) {        
        self.view.subviews.first?.subviews.first?.subviews.forEach { view in
            view.backgroundColor = color
        }
    }
}
