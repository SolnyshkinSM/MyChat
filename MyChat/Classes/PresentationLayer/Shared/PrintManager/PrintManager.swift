//
//  PrintManager.swift
//  MyChat
//
//  Created by Administrator on 11.04.2021.
//

import UIKit

// MARK: - PrintManager

class PrintManager: PrintManagerProtocol {
    
    // MARK: - Static properties
    
    static let shared = PrintManager()
    
    // MARK: - Private properties
    
    private static var state = ""
    
    // MARK: - Public methods
    
    func printLifecycleEvent(_ method: String = #function) {
        
        if ProcessInfo.processInfo.environment["log_lifecycle_events"] == "true" {
            
            if #available(iOS 13.0, *) {
                
                var scurrentState = ""
                
                switch UIApplication.shared.connectedScenes.first?.activationState.rawValue {
                case -1: scurrentState = "Unattached"
                case 1: scurrentState = "ForegroundInactive"
                case 0: scurrentState = "ForegroundActive"
                case 2: scurrentState = "Background"
                default: break
                }
                
                print("Application moved from '\(PrintManager.state)' to '\(scurrentState)': " + method)
                PrintManager.state = scurrentState
            }
        }
    }    
}
