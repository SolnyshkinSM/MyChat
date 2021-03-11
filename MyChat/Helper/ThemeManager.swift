//
//  ThemeManager.swift
//  MyChat
//
//  Created by Administrator on 06.03.2021.
//

import UIKit

// MARK: - Theme

enum Theme: Int {
    
    case `default`, day, night
    
    var tintColor: UIColor {
        switch self {
        case .default, .day:
            return .black
        case .night:
            return .white
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .default:
            return .white
        case .day:
            return #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        case .night:
            return .black
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .default, .day:
            return .black
        case .night:
            return .white
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .default, .day:
            return .default
        case .night:
            return .black
        }
    }
    
    var keyboardAppearance: UIKeyboardAppearance {
        switch self {
        case .default, .day:
            return .default
        case .night:
            return .dark
        }
    }
    
    var barViewColor: UIColor {
        switch self {
        case .default, .day:
            return #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        case .night:
            return #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
        }
    }
    
    var buttonTintColor: UIColor {
        switch self {
        case .default, .day, .night:
            return #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        }
    }
    
    var profileImageButtonColor: UIColor {
        switch self {
        case .default, .day, .night:
            return #colorLiteral(red: 0.8941176471, green: 0.9098039216, blue: 0.168627451, alpha: 1)
        }
    }
    
    var buttonBackgroundColor: UIColor {
        switch self {
        case .default, .day:
            return #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        case .night:
            return #colorLiteral(red: 0.1058823529, green: 0.1058823529, blue: 0.1058823529, alpha: 1)
        }
    }
    
}

// MARK: - ThemeManager

class ThemeManager {
    
    init() {
        //print("ThemeManager init")
    }
    
    deinit {
        //print("ThemeManager deinit")
    }
    
    static let shared = ThemeManager()
    
    static let selectedTheme = "SelectedTheme"
    
    var currentViewController: UIViewController?
    
    var currentTheme: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: ThemeManager.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .default
    }
    
    let closureApplyTheme = { (theme: Theme) in
                
        UserDefaults.standard.set(theme.rawValue, forKey: ThemeManager.selectedTheme)
        UserDefaults.standard.synchronize()
        
        UIView.appearance().tintColor = theme.tintColor
        UINavigationBar.appearance().barStyle = theme.barStyle
        
        UITextField.appearance().keyboardAppearance = theme.keyboardAppearance
        UITextField.appearance().textColor = theme.textColor
        UITextField.appearance().backgroundColor = theme.backgroundColor
        
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
    
    lazy var closureApplyThemeRetainCycle = { [self] (theme: Theme) in
        self.closureApplyTheme(theme)
    }
    
    func applyTheme(_ theme: Theme = shared.currentTheme) {
        
        UserDefaults.standard.set(theme.rawValue, forKey: ThemeManager.selectedTheme)
        UserDefaults.standard.synchronize()
        
        UIView.appearance().tintColor = theme.tintColor
        UINavigationBar.appearance().barStyle = theme.barStyle
        
        UITextField.appearance().keyboardAppearance = theme.keyboardAppearance
        UITextField.appearance().textColor = theme.textColor
        UITextField.appearance().backgroundColor = theme.backgroundColor
        
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
