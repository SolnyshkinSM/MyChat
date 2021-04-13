//
//  ThemeManager.swift
//  MyChat
//
//  Created by Administrator on 06.03.2021.
//

import UIKit

// MARK: - ThemeManager

class ThemeManager: ThemeManagerProtocol {
    
    // MARK: - Static properties

    static let shared = ThemeManager()
    
    // MARK: - Public properties
    
    var currentTheme: Theme {

        // UserDefaults
        // let storedTheme = UserDefaults.standard.integer(forKey: "SelectedTheme")
        // return Theme(rawValue: storedTheme) ?? .default

        // FileWorkManager
        var theme: Theme = .default
        FileWorkManager<Settings>().read { result in
                switch result {
                case .success(let resultTheme):
                    theme = Theme(rawValue: resultTheme.theme) ?? .default
                case .failure:
                    break
                }
        }
        return theme
    }
    
    // MARK: - Public methods

    func applyTheme(_ theme: Theme = shared.currentTheme) {
        
        // UserDefaults
        // UserDefaults.standard.set(theme.rawValue, forKey: "SelectedTheme")
        // UserDefaults.standard.synchronize()

        // GCDFileLoader
        GCDFileLoader.shared.writeFile(object: Settings(theme: theme.rawValue)) { _ in }

        UIView.appearance().tintColor = theme.tintColor
        UINavigationBar.appearance().barStyle = theme.barStyle
        UIRefreshControl.appearance().tintColor = theme.tintColor

        UITextField.appearance().keyboardAppearance = theme.keyboardAppearance
        UITextField.appearance().textColor = theme.textColor
        UITextField.appearance().backgroundColor = theme.textFieldbackgroundColor

        UILabel.appearance(whenContainedInInstancesOf: [UITableView.self]).textColor = theme.textColor

        UIView.appearance(whenContainedInInstancesOf:
                            [ThemesViewController.self]).backgroundColor = theme.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf:
                            [ThemesViewController.self]).textColor = theme.textColor

        UIView.appearance(whenContainedInInstancesOf:
                            [ConversationsListViewController.self]).backgroundColor = theme.backgroundColor

        UIView.appearance(whenContainedInInstancesOf:
                            [ConversationViewController.self]).backgroundColor = theme.backgroundColor

        UIView.appearance(whenContainedInInstancesOf:
                            [ProfileViewController.self]).backgroundColor = theme.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf:
                            [ProfileViewController.self]).textColor = theme.textColor
    }
}
