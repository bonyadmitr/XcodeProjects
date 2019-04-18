//
//  AppDelegate.swift
//  KeyboardStateListener
//
//  Created by Bondar Yaroslav on 4/17/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = ScrollController()
        
        
        return true
    }
}

