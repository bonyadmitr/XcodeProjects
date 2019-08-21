//
//  AppDelegate.swift
//  MuteMic
//
//  Created by Bondar Yaroslav on 8/17/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

// TODO: clear file
// TODO: clear storyboard and window
// TODO: right click menu (statusItemMenu)
// TODO: launch at login

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    /// NSStatusBar.system should be called after applicationDidFinishLaunching. use lazy init.
    lazy var statusItemManager = StatusItemManager()
    
    let audioManager = MuteMicManager.shared

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItemManager.setup()
        
        statusItemManager.setImage(for: audioManager.isMuted())
        audioManager.didChange = { [weak self] isMuted in
            DispatchQueue.main.async {
                self?.statusItemManager.setImage(for: isMuted)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {}
}


extension Optional {
    func assert(or defaultValue: Wrapped) -> Wrapped {
        switch self {
        case .none:
            assertionFailure()
            return defaultValue
        case .some(let value):
            return value
        }
    }
    
    /**
     it is nonescaping, so there is no perfermance issue
     
         text.assertExecute { print($0) }
     
    vs
     
         if let text = text {
             print(text)
         } else {
             assertionFailure()
         }
    
    */
    // TODO: check with and without "rethrows"
    func assertExecute(_ action: (Wrapped) throws -> Void) rethrows {
        switch self {
        case .none:
            assertionFailure()
        case .some(let value):
            try action(value)
        }
    }
}
