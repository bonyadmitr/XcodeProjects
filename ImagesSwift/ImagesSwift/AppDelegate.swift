//
//  AppDelegate.swift
//  ImagesSwift
//
//  Created by Bondar Yaroslav on 12/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
        window.backgroundColor = UIColor.cyan
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}

