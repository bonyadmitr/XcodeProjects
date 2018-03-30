//
//  AppDelegate.swift
//  FacebookTest
//
//  Created by Bondar Yaroslav on 04/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UserProfile.updatesOnAccessTokenChange = true
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        SDKApplicationDelegate.shared.application(app, open: url, options: options)
        if url.scheme!.isEqual("fb1282555368465909") {
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
    }
    func applicationWillTerminate(_ application: UIApplication) {
    }
}

