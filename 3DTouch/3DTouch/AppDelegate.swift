//
//  AppDelegate.swift
//  3DTouch
//
//  Created by Bondar Yaroslav on 11/5/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

enum Shortcut: String {
    case openBlue = "OpenBlue"
    case some1 = "some1"
    case some2 = "some2"
}

/// quick action can be handled from "didFinishLaunchingWithOptions" (at launch) or "performActionFor shortcutItem:" (when in memory)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// Temporary variable to hold a shortcut item from the launching or activation of the app.
    //private var shortcutItemToProcess: UIApplicationShortcutItem?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /// If launchOptions contains the appropriate launch options key, a Home screen quick action
        /// is responsible for launching the app. Store the action for processing once the app has
        /// completed initialization.
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            //shortcutItemToProcess = shortcutItem
            _ = handleQuickAction(shortcutItem)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        /// Alternatively, a shortcut item may be passed in through this delegate method if the app was
        /// still in memory when the Home screen quick action was used. Again, store it for processing.
        //shortcutItemToProcess = shortcutItem
        
        /// apple sample code dont use completionHandler.
        completionHandler(handleQuickAction(shortcutItem))
    }
    
    private func handleQuickAction(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        /// Is there a shortcut item that has not yet been processed?
//        guard let shortcutItem = shortcutItemToProcess else {
//            return false
//        }
        
        guard
            let shortcutType = Shortcut(rawValue: shortcutItem.type),
            let nacVC = window?.rootViewController as? UINavigationController,
            let vc = nacVC.topViewController
        else {
            assertionFailure()
            return false
        }
        
        switch shortcutType {
        case .openBlue:
            vc.view.backgroundColor = UIColor(red: 151.0/255.0, green: 187.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        case .some1:
            vc.view.backgroundColor = .red
        case .some2:
            vc.view.backgroundColor = .cyan
        }
        
        /// Reset the shorcut item so it's never processed twice.
//        shortcutItemToProcess = nil
        
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        
        /// from apple
        //handleQuickAction()
        
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

