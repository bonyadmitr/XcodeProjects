//
//  AppDelegate.swift
//  FirebaseTest
//
//  Created by Yaroslav Bondar on 16/07/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import UIKit

/// need only for line: Fabric.with([Crashlytics.self])
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseSerivce().configureFirebase()
        
        AnalyticsService.shared.log(event: "app_start")
        
        /// https://fabric.io/kits/ios/crashlytics/install
        ///
        /// Turn off automatic collection with a new key to your Info.plist file
        /// Key: firebase_crashlytics_collection_enabled, Value: false
        /// Enable collection for selected users by initializing Crashlytics at runtime
//        Fabric.with([Crashlytics.self])
        
        log("app_start")
        logLine()
        
        return true
    }
}
