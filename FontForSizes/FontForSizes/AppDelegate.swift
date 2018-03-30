//
//  AppDelegate.swift
//  FontForSizes
//
//  Created by Bondar Yaroslav on 24/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
//        UILabel.appearance(for: UITraitCollection(userInterfaceIdiom: .phone))
        
//        setSizes()
        set(label: UILabel.appearance())
//        UILabel.appearance().font = Fonts.textForDevice(with: 10)
        return true
    }
    
    func set(label: UILabel) {
        label.font = Fonts.textForDevice(with: 10)
//        label.transform = CGAffineTransform(scaleX: 3, y: 3)
//        label.layer.rasterizationScale = UIScreen.main.scale
//        label.layer.shouldRasterize = true
    }
    
    
    func setSizes() {
        if UIScreen.main.bounds.height == 480 { // iPhone 4
            UILabel.appearance().contentScaleFactor = 1
        } else if UIScreen.main.bounds.height == 568 { // IPhone 5
            
//            UILabel.appearance().contentScaleFactor = 2
        } else if UIScreen.main.bounds.width == 375 { // iPhone 6
            UILabel.appearance().contentScaleFactor = 3
        } else if UIScreen.main.bounds.width == 414 { // iPhone 6+
            UILabel.appearance().contentScaleFactor = 4
        } else if UIScreen.main.bounds.width == 768 { // iPad
            UILabel.appearance().contentScaleFactor = 5
        }
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

