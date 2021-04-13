//
//  ChannelsManager.swift
//  MyChat
//
//  Created by Administrator on 10.04.2021.
//

import UIKit

// MARK: - ChannelsManager

class ChannelsManager: ChannelsManagerProtocol {
    
    // MARK: - Private properties
    
    private let viewController: UIViewController
    
    private let theme = ThemeManager.shared.currentTheme
    
    private let createButtonHandler: (_ alert: UIAlertController) -> Void
    
    // MARK: - Initialization
    
    init(viewController: UIViewController,
         createButtonHandler: @escaping (_ alert: UIAlertController) -> Void) {
        self.viewController = viewController
        self.createButtonHandler = createButtonHandler
    }
    
    // MARK: - Public methods
   
    func addNewChannel() {
        
        let alert = UIAlertController(title: "Enter channel name",
                                      message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let createButton = UIAlertAction(title: "Create", style: .default) { [unowned alert] _ in
            self.createButtonHandler(alert)
        }
        alert.addAction(createButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(cancelButton)
        
        alert.setBackgroundColor(color: theme.buttonBackgroundColor)
        
        viewController.present(alert, animated: true)
    }    
}
