//
//  AppDelegate.swift
//  GenericTableViewController
//
//  Created by zdaecqze zdaecq on 02.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var app: App?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        app = App(window: window!)
        
        return true
    }
}

