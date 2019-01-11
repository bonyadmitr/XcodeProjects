//
//  AppDelegate.swift
//  Background
//
//  Created by Bondar Yaroslav on 7/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import CoreLocation

/// https://habr.com/post/271505/
/// https://developer.apple.com/library/archive/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/BackgroundExecution/BackgroundExecution.html
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        if launchOptions?[.location] != nil {
            debugLog("didFinishLaunchingWithOptions from location !!!")
        }
        
        debugLog("didFinishLaunchingWithOptions: \(launchOptions ?? [:])")
        BackgroundLocationManager.shared.delegate = self
        BackgroundLocationManager.shared.startUpdateLocation()
        BackgroundTaskManager.shared.beginBackgroundTask()
        
        /// only UIApplicationSignificantTimeChange notification has object: UIApplication. userInfo is nil in both ones.
        /// on new day notification will be called with small delay
        /// will not be called in background. will be called after open app
        NotificationCenter.default.addObserver(self, selector: #selector(dateDidChange), name: .NSCalendarDayChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dateDidChange), name: .UIApplicationSignificantTimeChange, object: nil)
        
        /// https://developer.apple.com/documentation/uikit/core_app/managing_your_app_s_life_cycle/preparing_your_app_to_run_in_the_background/updating_your_app_with_background_app_refresh
        /// https://developer.apple.com/documentation/uikit/uiapplication/1622994-backgroundrefreshstatus
        /// https://www.raywenderlich.com/5817-background-modes-tutorial-getting-started
        /// https://habr.com/post/208434/
        /// UIApplicationBackgroundFetchIntervalMinimum (simulator iOS 12 = 0.0)
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        switch application.backgroundRefreshStatus {
        case .restricted:
            print("backgroundRefreshStatus restricted")
        case .denied:
            print("backgroundRefreshStatus denied")
        case .available:
            print("backgroundRefreshStatus available")
        }
        
        return true
    }
    
    @objc private func dateDidChange(_ notification: Notification) {
        debugLog("notification: \(notification.name.rawValue)")
        debugLog("date: \(Date())")
    }
    
    /// max 30 sec
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("- Background Fetch performFetchWithCompletionHandler")
        BackgroundTaskManager.shared.restartBackgroundTask()
        completionHandler(.newData)
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
        
        debugLog("didUpdate(location")
        BackgroundTaskManager.shared.restartBackgroundTask()
        
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
    }
}

