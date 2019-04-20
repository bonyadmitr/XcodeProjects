//
//  AppDelegate.swift
//  LaunchAtLogin
//
//  Created by Bondar Yaroslav on 4/19/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa
import ServiceManagement

//extension Notification.Name {
//    static let killLauncher = Notification.Name("killLauncher")
//}
//
//@NSApplicationMain
//class AppDelegate: NSObject, NSApplicationDelegate {
//
//    @IBAction func startAtLogin(_ sender: NSMenuItem) {
//
//        if sender.state == .on {
//            sender.state = .off
//
//            SMLoginItemSetEnabled("com.by.LaunchAtLogin" as CFString, true)
//
////            StartupLaunch.setLaunchOnLogin(false)
//        } else {
//            sender.state = .on
////            StartupLaunch.setLaunchOnLogin(true)
//        }
//
////        toggleLaunchAtStartup()
//        print(StartupLaunch.isAppLoginItem)
//    }
//
//    func applicationDidFinishLaunching(_ aNotification: Notification) {
//
//        let launcherAppId = "com.by.LaunchAtLoginLauncher"
//        let runningApps = NSWorkspace.shared.runningApplications
//        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty
//
//        SMLoginItemSetEnabled(launcherAppId as CFString, true)
//
//        if isRunning {
//            DistributedNotificationCenter.default().post(name: .killLauncher,
//                                                         object: Bundle.main.bundleIdentifier ?? "")
//        }
//
//    }
//
//    func applicationWillTerminate(_ aNotification: Notification) {
//        // Insert code here to tear down your application
//    }
//
//
//}



import Cocoa
import ServiceManagement

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

@NSApplicationMain
class AppDelegate: NSObject {}


extension AppDelegate: NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let launcherAppId = "com.by.LaunchAtLoginLauncher"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty
        
        SMLoginItemSetEnabled(launcherAppId as CFString, true)
        
        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher,
                                                         object: Bundle.main.bundleIdentifier!)
        }
    }
}
