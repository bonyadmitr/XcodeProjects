//
//  AppDelegate.swift
//  LaunchAtLoginTest
//
//  Created by Bondar Yaroslav on 4/24/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa
import LaunchAtLogin

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        /// https://github.com/sindresorhus/LaunchAtLogin
        print(LaunchAtLogin.isEnabled)
        //=> false
        
        LaunchAtLogin.isEnabled = true
        
        print(LaunchAtLogin.isEnabled)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

