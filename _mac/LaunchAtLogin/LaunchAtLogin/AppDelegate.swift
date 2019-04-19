//
//  AppDelegate.swift
//  LaunchAtLogin
//
//  Created by Bondar Yaroslav on 4/19/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBAction func startAtLogin(_ sender: NSMenuItem) {
        
        if sender.state == .on {
            sender.state = .off
            StartupLaunch.setLaunchOnLogin(false)
        } else {
            sender.state = .on
            StartupLaunch.setLaunchOnLogin(true)
        }
        
//        toggleLaunchAtStartup()
        print(StartupLaunch.isAppLoginItem)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

