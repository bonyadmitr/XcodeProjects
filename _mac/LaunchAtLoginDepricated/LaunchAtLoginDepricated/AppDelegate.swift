//
//  AppDelegate.swift
//  LaunchAtLoginDepricated
//
//  Created by Bondar Yaroslav on 4/26/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var launchAtLoginMenuItem: NSMenuItem!
    
    @IBAction func onLaunchAtLoginMenuItem(_ sender: NSMenuItem) {
        
        print("was: \(LaunchAtLogin.isEnabled)")
        LaunchAtLogin.toggle()
        print("now: \(LaunchAtLogin.isEnabled)")
        
        //print(StartupLauncher.shared.isLaunchAtLogin)
        //StartupLauncher.shared.toggle()
        
        updateButton()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        updateButton()
    }
    
    private func updateButton() {
        let isLaunchAtLogin = LaunchAtLogin.isEnabled
        //let isLaunchAtLogin = StartupLauncher.shared.isLaunchAtLogin
        
        let state: NSControl.StateValue = isLaunchAtLogin ? .on : .off
        launchAtLoginMenuItem.state = state
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
