//
//  MainLaunchRouterMac.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 03/10/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Cocoa
import DipApplication

class MainLaunchRouter: LaunchRouter {
    let window: NSWindowController
    let storyboard: NSStoryboard
    
    
    init(window: NSWindowController, storyboard: NSStoryboard) {
        self.window = window
        self.storyboard = storyboard
    }
    
    func openInitialModule() {
//        let mainVc = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "www")) as! NSViewController
//        window.window?.contentViewController = mainVc
        window.window?.makeKeyAndOrderFront(nil)
    }
}
