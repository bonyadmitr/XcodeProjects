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
class AppDelegate: NSObject {
    
    let helperBundleName = "com.by.LaunchAtLoginLauncher"
    
    @IBOutlet weak var launchAtLoginMenuItem: NSMenuItem!
    
    @IBAction func onLaunchAtLoginMenuItem(_ sender: NSMenuItem) {
        
        if sender.state == .on {
            sender.state = .off
            SMLoginItemSetEnabled(helperBundleName as CFString, false)
        } else {
            sender.state = .on
            SMLoginItemSetEnabled(helperBundleName as CFString, true)
        }
        
//        let isAuto = sender.state != .on
//        SMLoginItemSetEnabled(helperBundleName as CFString, isAuto)
        
//        let foundHelper = NSWorkspace.shared.runningApplications.contains {
//            $0.bundleIdentifier == helperBundleName
//        }
//
//        launchAtLoginMenuItem.state = foundHelper ? .on : .off
    }
}


extension AppDelegate: NSApplicationDelegate {

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // TODO: test
        /// https://stackoverflow.com/a/44069825/5893286
        
        let foundHelper = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == helperBundleName
        }
        
        launchAtLoginMenuItem.state = foundHelper ? .on : .off

        
        
//        let runningApps = NSWorkspace.shared.runningApplications
//        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty
//
//        SMLoginItemSetEnabled(launcherAppId as CFString, true)
//
//        if isRunning {
//            DistributedNotificationCenter.default().post(name: .killLauncher,
//                                                         object: Bundle.main.bundleIdentifier!)
//        }
    }
}


/// new tutorials
/// https://stackoverflow.com/questions/35339277/make-swift-cocoa-app-launch-on-startup-on-os-x-10-11
///
/// https://github.com/sindresorhus/LaunchAtLogin
/// https://github.com/sindresorhus/LaunchAtLogin/blob/master/LaunchAtLogin/LaunchAtLogin.swift
/// https://github.com/sindresorhus/LaunchAtLogin/blob/master/LaunchAtLoginHelper/main.swift
