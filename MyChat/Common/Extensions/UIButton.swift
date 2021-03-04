//
//  UIButton.swift
//  MyChat
//
//  Created by Administrator on 24.02.2021.
//

import UIKit

// MARK: - UIButton

extension UIButton {
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let circlePath = UIBezierPath(ovalIn: self.bounds)
        return circlePath.contains(point)
    }
}
