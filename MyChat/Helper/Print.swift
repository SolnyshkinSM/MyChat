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
    }
}
