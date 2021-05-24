//
//  GestureRecognizerManager.swift
//  MyChat
//
//  Created by Administrator on 27.04.2021.
//

import UIKit

// MARK: - GestureRecognizerManager

class GestureRecognizerManager {

    // MARK: - Private properties

    private let view: UIView

    private var tinkoffCell: CAEmitterCell = {
        let snowCell = CAEmitterCell()
        snowCell.contents = UIImage(named: "blazonTinkoff.png")?.cgImage
        snowCell.scale = 0.3
        snowCell.scaleRange = 0.5
        snowCell.emissionRange = .pi
        snowCell.lifetime = 3.0
        snowCell.birthRate = 5
        snowCell.velocity = -10
        snowCell.velocityRange = -5
        snowCell.spin = 0.25
        snowCell.spinRange = 1.0
        return snowCell
    }()

    // MARK: - Initialization

    init(view: UIView) {
        self.view = view
    }

    // MARK: - Public methods

    @objc func longPressed(sender: UILongPressGestureRecognizer) {

        if sender.state == .began {
            blazonsTinkoff(for: sender.location(in: view))
        } else if sender.state == .ended {
            view.layer.sublayers?.removeLast()
        }
    }

    // MARK: - Private methods

    private func blazonsTinkoff(for touch: CGPoint?) {

        guard let touchPoint = touch else { return }

        let snowLayer = CAEmitterLayer()
        snowLayer.emitterPosition = touchPoint
        snowLayer.emitterSize = CGSize(width: view.bounds.width * 0.2, height: view.bounds.width * 0.2)
        snowLayer.emitterShape = .circle
        snowLayer.emitterCells = [tinkoffCell]
        view.layer.addSublayer(snowLayer)
    }
}
