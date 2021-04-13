//
//  PrintManagerProtocol.swift
//  MyChat
//
//  Created by Administrator on 11.04.2021.
//

import Foundation

// MARK: - PrintManagerProtocol

protocol PrintManagerProtocol {
    static var shared: PrintManager { get }
    func printLifecycleEvent(_ method: String)
}
