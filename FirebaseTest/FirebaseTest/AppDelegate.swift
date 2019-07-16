//
//  AppDelegate.swift
//  FirebaseTest
//
//  Created by Yaroslav Bondar on 16/07/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAnalytics
import Fabric
import Crashlytics

func crashlyticsLogsLine(file: String = #file, line: UInt = #line, functionName: String = #function) {
    let fileName = (file as NSString).lastPathComponent
    crashlyticsLogs("\(fileName) \(line) \(functionName)")
}

/// https://firebase.google.com/docs/crashlytics/customize-crash-reports
///
/// don't call before "Fabric.with([Crashlytics.self])"
func crashlyticsLogs(_ string: String) {
    CLSLogv("%@", getVaList([string]))
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        /// https://fabric.io/kits/ios/crashlytics/install
        ///
        /// Turn off automatic collection with a new key to your Info.plist file
        /// Key: firebase_crashlytics_collection_enabled, Value: false
        /// Enable collection for selected users by initializing Crashlytics at runtime
        Fabric.with([Crashlytics.self])
        
        crashlyticsLogs("app start")
        crashlyticsLogsLine()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

