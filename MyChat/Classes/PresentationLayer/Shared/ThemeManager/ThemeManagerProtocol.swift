//
//  ThemeManagerProtocol.swift
//  MyChat
//
//  Created by Administrator on 11.04.2021.
//

import Foundation

// MARK: - ThemeManagerProtocol

protocol ThemeManagerProtocol {
    static var shared: ThemeManager { get }
    var currentTheme: Theme { get }
    func applyTheme(_ theme: Theme)
}
