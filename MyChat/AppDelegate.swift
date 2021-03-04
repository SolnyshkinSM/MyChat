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
<<<<<<< HEAD
        printLifecycleEvent("Not running", to: "Inactive", method: #function)
=======
>>>>>>> e316bb15ff922efda2e347ca0515e2adc31aec1b
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
<<<<<<< HEAD
    
    func applicationWillResignActive(_ application: UIApplication) {
        printLifecycleEvent("Active", to: "Inactive", method: #function)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        printLifecycleEvent("Inactive", to: "Active", method: #function)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        printLifecycleEvent("Inactive", to: "Background", method: #function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        printLifecycleEvent("Background", to: "Foreground", method: #function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        printLifecycleEvent("", to: "Not running", method: #function)
    }

=======
>>>>>>> e316bb15ff922efda2e347ca0515e2adc31aec1b
}

