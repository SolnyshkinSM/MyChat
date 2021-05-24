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
    
    func configereCircleButton(theme: Theme) {
        
        layer.masksToBounds = true
        backgroundColor = theme.profileImageButtonColor
        layer.cornerRadius = bounds.height / 2
    }
    
    func shake() {
        
        if self.layer.animation(forKey: "shakeIt") != nil {
            self.layer.removeAnimation(forKey: "shakeIt")
            
            let animation = CABasicAnimation(keyPath: "transform")
            animation.duration = 2.0
            self.layer.add(animation, forKey: "transform")
                        
            return
        }
            
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [-18.0, 18.0].map { (degrees: Double) -> Double in
            let radians: Double = (.pi * degrees) / 180.0
            return radians
        }
        
        let translationX = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translationX.values = [-5.0, 5.0]
        
        let translationY = CAKeyframeAnimation(keyPath: "transform.translation.y")
        translationY.values = [-5.0, 5.0]
                
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        shakeGroup.animations = [rotation, translationX, translationY]
        shakeGroup.duration = 0.3
        shakeGroup.repeatCount = .infinity
        shakeGroup.autoreverses = true
            
        self.layer.add(shakeGroup, forKey: "shakeIt")
    }
}
