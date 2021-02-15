//
//  AppDelegate.swift
//  MyChat
//
//  Created by Administrator on 14.02.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        printApplicationMovedFrom("Not running", to: "Inactive", method: #function)
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        printApplicationMovedFrom("Active", to: "Inactive", method: #function)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        printApplicationMovedFrom("Inactive", to: "Active", method: #function)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        printApplicationMovedFrom("Inactive", to: "Background", method: #function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        printApplicationMovedFrom("Background", to: "Foreground", method: #function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        printApplicationMovedFrom("", to: "Not running", method: #function)
    }

}

