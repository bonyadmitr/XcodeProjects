//
//  AppDelegate.swift
//  Background
//
//  Created by Bondar Yaroslav on 7/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import CoreLocation

final class BackgroundTaskService {
    
    static let shared = BackgroundTaskService()
    
    private var backgroundTaskId = UIBackgroundTaskInvalid
    
    func beginBackgroundTask() {
        guard backgroundTaskId == UIBackgroundTaskInvalid else {
            DispatchQueue.main.async {
                debugLog("BACKGROUND backgroundTaskId == UIBackgroundTaskInvalid, backgroundTimeRemaining : \(UIApplication.shared.backgroundTimeRemaining)")
                //1.79769313486232E+308 means infinite time
            }
            return
        }
        
        backgroundTaskId = UIApplication.shared.beginBackgroundTask(withName: UUID().uuidString, expirationHandler: { [weak self] in
            debugLog("BACKGROUND expirationHandler")
            DispatchQueue.main.async {
                debugLog("BACKGROUND expirationHandler, backgroundTimeRemaining: \(UIApplication.shared.backgroundTimeRemaining)")
            }
            self?.endBackgroundTask()
        })
        
        DispatchQueue.main.async {
            debugLog("BACKGROUND backgroundTimeRemaining: \(UIApplication.shared.backgroundTimeRemaining)")
            //1.79769313486232E+308 means infinite time
        }
        debugLog("BACKGROUND: Task \(backgroundTaskId) has been added")
    }
    
    private func endBackgroundTask() {
        if backgroundTaskId != UIBackgroundTaskInvalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
            backgroundTaskId = UIBackgroundTaskInvalid
            debugLog("BACKGROUND: Task \(backgroundTaskId) has been ended")
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        debugLog("didFinishLaunchingWithOptions: \(launchOptions ?? [:])")
        BackgroundLocationManager.shared.delegate = self
        BackgroundLocationManager.shared.startUpdateLocation()
        BackgroundTaskService.shared.beginBackgroundTask()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        debugLog("applicationWillResignActive")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        debugLog("applicationDidEnterBackground")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        debugLog("applicationWillEnterForeground")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        debugLog("applicationDidBecomeActive")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        debugLog("applicationWillTerminate")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    var lastLocation: CLLocation?
    var lastDate: Date?
}

extension AppDelegate: LocationManagerDelegate {
    func didUpdate(location: CLLocation) {
        
        if let lastLocation = lastLocation {
            let distance = lastLocation.distance(from: location) /// meters
            debugLog("distance: \(distance)")
        }
        
        if let lastDate = lastDate {
            let newDate = Date()
            let timeDifference = -lastDate.timeIntervalSince(newDate)
            debugLog("timeDifference: \(timeDifference)")
            self.lastDate = newDate
        } else {
            lastDate = Date()
        }
        
        lastLocation = location
        debugLog(location)
    }
}

