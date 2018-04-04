//
//  AppDelegate.swift
//  DropboxSdk
//
//  Created by Bondar Yaroslav on 4/4/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        DropboxManager.shared.prepareForUse(with: "2ettjg3gh8318zt")
        
        return true
    }

    /// iOS 9+
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if DropboxManager.shared.handleRedirect(url: url) {
            return true
        }
        return false

    }
    
    /// iOS 8-
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if DropboxManager.shared.handleRedirect(url: url) {
            return true
        }
        return false
    }
}
