//
//  BubbleView.swift
//  MyChat
//
//  Created by Administrator on 03.03.2021.
//

import UIKit

// MARK: - BubbleView

class BubbleView: UIView {

    // MARK: - Public properties

    var inbox = true {
        didSet { setNeedsDisplay() }
    }

    // MARK: - UIViewRendering

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let rectCorner: UIRectCorner = inbox ?
            [.topLeft, .bottomRight] : [.topRight, .bottomLeft]

        let bezierPath = UIBezierPath(roundedRect: rect,
                                      byRoundingCorners: rectCorner,
                                      cornerRadii: CGSize(width: 35, height: 35))

        switch ThemeManager.shared.currentTheme {
        case .default: (inbox ? #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1) : #colorLiteral(red: 0.862745098, green: 0.968627451, blue: 0.7725490196, alpha: 1)).setFill()
        case .day: (inbox ? #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1) : #colorLiteral(red: 0.262745098, green: 0.537254902, blue: 0.9764705882, alpha: 1)).setFill()
        case .night: (inbox ? #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1) : #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)).setFill()
        }

        bezierPath.fill()
        bezierPath.close()
    }
}
