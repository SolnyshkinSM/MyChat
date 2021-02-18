//
//  Print.swift
//  MyChat
//
//  Created by Administrator on 14.02.2021.
//

import UIKit

var state = ""

func printLifecycleEvent(_ method: String = #function) {
    
    if ProcessInfo.processInfo.environment["log_lifecycle_events"] == "true" {
        
        var scurrentState = ""
        switch UIApplication.shared.applicationState.rawValue {
        case 0: scurrentState = "Active"
        case 1: scurrentState = "Inctive"
        case 2: scurrentState = "Background"
        default: break
        }
        
        print("Application moved from '\(state)' to '\(scurrentState)': " + method)
        state = scurrentState
    }
}
