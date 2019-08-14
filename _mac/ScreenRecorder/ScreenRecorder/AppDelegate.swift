//
//  AppDelegate.swift
//  ScreenRecorder
//
//  Created by Bondar Yaroslav on 8/14/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        if FileManager.default.fileExists(atPath: videoDestination.path) {
            try? FileManager.default.removeItem(atPath: videoDestination.path)
        }
    }


}

