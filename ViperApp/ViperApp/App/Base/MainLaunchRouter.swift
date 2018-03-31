//
//  MainLaunchRouter.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 20/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class MainLaunchRouter: LaunchRouter {
    let window: UIWindow
    let storyboard: UIStoryboard
    
    init(window: UIWindow, storyboard: UIStoryboard) {
        self.window = window
        self.storyboard = storyboard
    }
    
    func openInitialModule() {
        let controller = storyboard.instantiateInitialViewController()
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}
