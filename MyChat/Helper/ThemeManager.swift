//
//  ThemeManager.swift
//  MyChat
//
//  Created by Administrator on 06.03.2021.
//

import UIKit

/*enum Theme: Int {
 
 case theme1, theme2
 
 var backgroundColor: UIColor {
 switch self {
 case .theme1:
 return UIColor(hexaRGBA: "#EBEBEB") ?? .white
 case .theme2:
 return UIColor(hexaRGBA: "#919191") ?? .white
 }
 }
 }
 
 let selectedThemeKey = "SelectedTheme"
 
 class ThemeManager {
 
 static func currentTheme() -> Theme {
 
 if let storedTheme = (UserDefaults.standard.value(forKey: selectedThemeKey) as AnyObject).integerValue {
 return Theme(rawValue: storedTheme) ?? .theme1
 } else {
 return .theme1
 }
 }
 
 static func applyTheme(theme: Theme) {
 
 UserDefaults.standard.setValue(theme.rawValue, forKey: selectedThemeKey)
 UserDefaults.standard.synchronize()
 
 UIButton.appearance().backgroundColor = theme.backgroundColor
 }
 }*/



enum Theme: Int {
    
    case `default`, day, night
    
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .default
    }
    
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
        
    func apply() {
        
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()
        
        //UIApplication.shared.delegate?.window??.tintColor = mainColor
        
        UIView.appearance().tintColor = tintColor
        
        //UIWindow.appearance().backgroundColor = mainColor
        
        UINavigationBar.appearance().barStyle = barStyle
        //UINavigationBar.appearance().setBackgroundImage(navigationBackgroundImage, for: .default)
        
        
        UIView.appearance(whenContainedInInstancesOf: [ThemesViewController.self]).backgroundColor = backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [ThemesViewController.self]).textColor = textColor
        
        
        //UITableViewCell.appearance().backgroundColor = backgroundColor
        //UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
        //UILabel.appearance().textColor = textColor
        UIView.appearance(whenContainedInInstancesOf: [ConversationsListViewController.self]).backgroundColor = backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableView.self]).textColor = textColor
        
        
        
        UIView.appearance(whenContainedInInstancesOf: [ConversationViewController.self]).backgroundColor = backgroundColor
        //UILabel.appearance(whenContainedInInstancesOf: [UITextField.self]).tintColor = .white
        //UILabel.appearance(whenContainedInInstancesOf: [UITextField.self]).textColor = .white
        //UIView.appearance(whenContainedInInstancesOf: [ConversationViewController.self]).backgroundColor = backgroundColor
        
        UITextField.appearance().keyboardAppearance = keyboardAppearance
        //UITextField.appearance().tintColor = mainColor
        //UITextField.appearance().textColor = mainColor
        //UITextField.appearance().attributedPlaceholder = .init()
        
        UITextField.appearance().textColor = textColor
        
        UITextField.appearance().backgroundColor = backgroundColor
        
        
        
        
        
        UIView.appearance(whenContainedInInstancesOf: [ProfileViewController.self]).backgroundColor = backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [ProfileViewController.self]).textColor = textColor
        
        //UILabel.appearance(whenContainedInInstancesOf: [UIButton.self]).tintColor = buttonTintColor
        
        
    }
    
    
    
    
    
    
    
}
