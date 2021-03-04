//
//  Print.swift
//  MyChat
//
//  Created by Administrator on 14.02.2021.
//

import Foundation

func printLifecycleEvent(_ state: String, to: String, method: String) {
    if ProcessInfo.processInfo.environment["log_lifecycle_events"] == "true" {
<<<<<<< HEAD
        print("Application moved from '\(state)' to '\(to)': " + method)
=======
        
        if #available(iOS 13.0, *) {
            
            var scurrentState = ""
            
            switch UIApplication.shared.connectedScenes.first?.activationState.rawValue {
            case -1: scurrentState = "Unattached"
            case 1: scurrentState = "ForegroundInactive"
            case 0: scurrentState = "ForegroundActive"
            case 2: scurrentState = "Background"
            default: break
            }
            
            print("Application moved from '\(state)' to '\(scurrentState)': " + method)
            state = scurrentState
        }
>>>>>>> e316bb15ff922efda2e347ca0515e2adc31aec1b
    }
}
