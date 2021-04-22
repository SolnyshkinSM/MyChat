//
//  Theme.swift
//  MyChat
//
//  Created by Administrator on 12.04.2021.
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

    var contentViewColor: UIColor {
        switch self {
        case .default:
            return .white
        case .day:
            return #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        case .night:
            return .black
        }
    }

    var shadowColor: UIColor {
        switch self {
        case .default, .day:
            return .black
        case .night:
            return .white
        }
    }
}
