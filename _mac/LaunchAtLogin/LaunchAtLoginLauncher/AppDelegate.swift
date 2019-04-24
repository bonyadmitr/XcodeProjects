//
//  AppDelegate.swift
//  LaunchAtLoginLauncher
//
//  Created by Bondar Yaroslav on 4/19/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

//extension Notification.Name {
//    static let killLauncher = Notification.Name("killLauncher")
//}
//
//@NSApplicationMain
//class AppDelegate: NSObject, NSApplicationDelegate {
//
//    @IBOutlet weak var window: NSWindow!
//
//    @objc func terminate() {
//        NSApp.terminate(nil)
//    }
//
//    func applicationDidFinishLaunching(_ aNotification: Notification) {
//
//        print(Bundle.main.bundleIdentifier ?? "nil")
//        let mainAppIdentifier = "com.by.LaunchAtLogin"
//        let runningApps = NSWorkspace.shared.runningApplications
//        let isRunning = !runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.isEmpty
//
//        if !isRunning {
//            DistributedNotificationCenter.default().addObserver(self,
//                                                                selector: #selector(self.terminate),
//                                                                name: .killLauncher,
//                                                                object: mainAppIdentifier)
//
//            let path = Bundle.main.bundlePath as NSString
//            var components = path.pathComponents
//            components.removeLast()
//            components.removeLast()
//            components.removeLast()
//            components.append("MacOS")
//            components.append("MainApplication") //main app name
//
//            let newPath = NSString.path(withComponents: components)
//
//            NSWorkspace.shared.launchApplication(newPath)
//        }
//        else {
//            self.terminate()
//        }
//
//
//    }
//
//    func applicationWillTerminate(_ aNotification: Notification) {
//        // Insert code here to tear down your application
//    }
//
//
//}
//

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

@NSApplicationMain
class AppDelegate: NSObject {
    
    @objc func terminate() {
        NSApp.terminate(nil)
    }
}

extension AppDelegate: NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
//        let mainAppIdentifier = "com.by.LaunchAtLogin"
//        let runningApps = NSWorkspace.shared.runningApplications
//        let isRunning = !runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.isEmpty
//
//        if !isRunning {
//            DistributedNotificationCenter.default().addObserver(self,
//                                                                selector: #selector(self.terminate),
//                                                                name: .killLauncher,
//                                                                object: mainAppIdentifier)
//
//            let path = Bundle.main.bundlePath as NSString
//            var components = path.pathComponents
//            components.removeLast()
//            components.removeLast()
//            components.removeLast()
//            components.append("MacOS")
//            components.append("MainApplication") //main app name
//
//            let newPath = NSString.path(withComponents: components)
//
//            NSWorkspace.shared.launchApplication(newPath)
//        }
//        else {
//            self.terminate()
//        }
        
        let mainBundleId = "com.by.LaunchAtLogin"
        
        // Ensure the app is not already running
        guard NSRunningApplication.runningApplications(withBundleIdentifier: mainBundleId).isEmpty else {
            NSApp.terminate(nil)
            return
        }
        
        let pathComponents = (Bundle.main.bundlePath as NSString).pathComponents
        let mainPath = NSString.path(withComponents: Array(pathComponents[0...(pathComponents.count - 5)]))
        NSWorkspace.shared.launchApplication(mainPath)
        NSApp.terminate(nil)
    }
}

