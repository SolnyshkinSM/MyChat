//
//  AnimatorPresent.swift
//  MyChat
//
//  Created by Administrator on 25.04.2021.
//

import UIKit

// MARK: - AnimatorPresent

class AnimatorPresent: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Public methods

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }

        containerView.addSubview(toView)

        let oldFrame = toView.frame
        toView.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        toView.frame = oldFrame

        let oldTransform = toView.transform
        toView.transform = CGAffineTransform(rotationAngle: .pi)

        UIView.animate(withDuration: 1, delay: 0,
                       usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut) {
            toView.transform = oldTransform
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension AnimatorPresent: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimatorPresent()
    }

    /*func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
     return AnimatorPresent()
     }*/
}
