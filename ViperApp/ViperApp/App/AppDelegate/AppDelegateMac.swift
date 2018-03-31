//
//  AppDelegateMac.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 03/10/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation
import DipApplication

final class AppDelegate: NSObject, AppDelegateHandler {
    
    var mainRouter: LaunchRouter!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainRouter.openInitialModule()
    }
}
