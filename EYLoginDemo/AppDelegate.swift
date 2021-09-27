//
//  AppDelegate.swift
//  EYLoginDemo
//
//  Created by eric on 2021/3/19.
//

import UIKit
import EYLoginSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        EYLoginSDKManager.shared().initializeSDK(appkey: "test001", secretkey: "cef4324399bb46f3b4a41d6895a30389", status: 1)
//        EYLoginSDKManager.shared().initializeSDK(appkey: "test002", secretkey: "fa1d6e933ff0424893ed851ce3d507a4", status: 2)
//        EYLoginSDKManager.shared().initializeSDK(appkey: "test003", secretkey: "b32dcf5700f44a9ab3e40d9222abb78c", status: 3)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

