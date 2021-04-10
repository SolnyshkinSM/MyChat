//
//  ScreenSaver.swift
//  MyChat
//
//  Created by Administrator on 10.04.2021.
//

import UIKit

// MARK: - ScreenSaver

class ScreenSaver {
    
    // MARK: - Private properties
    
    private let viewController: UIViewController
    
    private let theme = ThemeManager.shared.currentTheme
    
    // MARK: - Initialization
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Public methods
    
    func loadScreenSaver() {

        let screensaver = UIImageView(frame: viewController.view.bounds)
        screensaver.backgroundColor = theme.backgroundColor
        screensaver.contentMode = .center
        screensaver.image = UIImage(named: "logo")
        screensaver.clipsToBounds = true
        viewController.view.addSubview(screensaver)

        UIView.animate(withDuration: 3) {
            screensaver.alpha = 0
            self.viewController.navigationController?.navigationBar.alpha = 1
        }
    }
}
