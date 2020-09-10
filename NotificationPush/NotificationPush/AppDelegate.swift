//
//  AppDelegate.swift
//  NotificationPush
//
//  Created by Yaroslav Bondr on 09.09.2020.
//  Copyright © 2020 Yaroslav Bondr. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

