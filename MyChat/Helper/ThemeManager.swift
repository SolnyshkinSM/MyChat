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
    
    var textFieldbackgroundColor: UIColor {
        switch self {
        case .default:
            return #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        case .day:
            return #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        case .night:
            return #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        }
    }
}

// MARK: - ThemeManager

class ThemeManager {
        
    static let shared = ThemeManager()
    
    static let selectedTheme = "SelectedTheme"
    
    var currentViewController: UIViewController?
    
    var currentTheme: Theme {
        
        //UserDefaults
        //let storedTheme = UserDefaults.standard.integer(forKey: ThemeManager.selectedTheme)
        //return Theme(rawValue: storedTheme) ?? .default
        
        //FileWorkManager
        var theme: Theme = .default
        FileWorkManager<Settings>().read() { result in
                switch result {
                case .success(let resultTheme):
                    theme = Theme(rawValue: resultTheme.theme) ?? .default
                case .failure:
                    break
                }
        }
        return theme
    }
    
    let closureApplyTheme = { (theme: Theme) in
        
        //UserDefaults
        //UserDefaults.standard.set(theme.rawValue, forKey: ThemeManager.selectedTheme)
        //UserDefaults.standard.synchronize()
                
        //GCDFileLoader
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
    
    lazy var closureRetainCycle = { [self] in
        print(self)
    }
    
    func applyTheme(_ theme: Theme = shared.currentTheme) {
        
        //UserDefaults
        //UserDefaults.standard.set(theme.rawValue, forKey: ThemeManager.selectedTheme)
        //UserDefaults.standard.synchronize()
                
        //GCDFileLoader
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
