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
        print(StartupLauncher.shared.isLaunchAtLogin)
        StartupLauncher.shared.toggle()
        updateButton()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        updateButton()
    }
    
    private func updateButton() {
        let isLaunchAtLogin = StartupLauncher.shared.isLaunchAtLogin
        let state: NSControl.StateValue = isLaunchAtLogin ? .on : .off
        launchAtLoginMenuItem.state = state
        print(isLaunchAtLogin)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
