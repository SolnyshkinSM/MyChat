//
//  Print.swift
//  MyChat
//
//  Created by Administrator on 14.02.2021.
//

import Foundation

func printLifecycleEvent(_ state: String, to: String, method: String) {
    if ProcessInfo.processInfo.environment["log_lifecycle_events"] == "true" {
        print("Application moved from '\(state)' to '\(to)': " + method)
    }
}
