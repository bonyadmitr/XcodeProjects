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
//        toggleLaunchAtStartup()
//        StartupLaunch.setLaunchOnLogin(!StartupLaunch.isAppLoginItem)
        
//        let w = StartupLaunch2.shared.isAppLoginItem()
//        StartupLaunch2.shared.setLogin(login: !w)
        StartupLaunch2.shared.toggle()
        
        print(StartupLaunch2.shared.isAppLoginItem())
        
        print(StartupLaunch.isAppLoginItem)
        
        //let q = applicationIsInStartUpItems()
        let q = StartupLaunch2.shared.isAppLoginItem()
        print(q)
        let state: NSControl.StateValue = q ? .on : .off
        sender.state = state
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        print(StartupLaunch2.shared.isAppLoginItem())
        
        print(StartupLaunch.isAppLoginItem)
        let q = applicationIsInStartUpItems()
        print(q)
        let state: NSControl.StateValue = q ? .on : .off
        launchAtLoginMenuItem.state = state
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

