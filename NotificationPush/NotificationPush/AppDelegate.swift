//
//  AppDelegate.swift
//  NotificationPush
//
//  Created by Yaroslav Bondr on 09.09.2020.
//  Copyright © 2020 Yaroslav Bondr. All rights reserved.
//

import UIKit

/// to test silent in simulator needs performFetchWithCompletionHandler https://stackoverflow.com/a/60980549/5893286
/// silent revive th app https://stackoverflow.com/q/58128321/5893286
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationManager.shared.registerForPushNotifications()
//        let q = UserDefaults.standard.string(forKey: "1") ?? ""
//        UserDefaults.standard.set(q+"1", forKey: "1")
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

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
//        let q = UserDefaults.standard.string(forKey: "1") ?? ""
//        UserDefaults.standard.set(q+"2", forKey: "1")
        completionHandler(.newData)
    }
    
    
    
    /// system: You've implemented -[<UIApplicationDelegate> application:performFetchWithCompletionHandler:], but you still need to add "fetch" to the list of your supported UIBackgroundModes in your Info.plist.
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("silent push in simulator")
//        let q = UserDefaults.standard.string(forKey: "1") ?? ""
//        UserDefaults.standard.set(q+"3", forKey: "1")
        completionHandler(.newData)
    }
    
}

import UserNotifications

final class NotificationManager: NSObject {
    
    static let shared = NotificationManager()
    
    private let center = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        
        center.delegate = self
    }
    
    func registerForPushNotifications() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) {(granted, error) in
            print("Permission granted: \(granted)")
            
            // TODO: check need
            /// don't need for silent push in simulator
//            if granted {
//                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//            }
            
            if let error = error {
                print("requestAuthorization error: \(error.localizedDescription)")
            }
        }
    }
    
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    /// user action
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(response.actionIdentifier)
        print(response.notification.request.content.userInfo)
        completionHandler()
    }
    
    /// handle notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print(notification.request.content.userInfo)
        print("presenting")
        
        /// to show in active foreground app
        //completionHandler([.alert, .sound, .badge])
        
        /// to hide in active app
        /// will show in background app anyway
        completionHandler([])
        /// same from apple
        //completionHandler(UNNotificationPresentationOptions(rawValue: 0))
    }
}

