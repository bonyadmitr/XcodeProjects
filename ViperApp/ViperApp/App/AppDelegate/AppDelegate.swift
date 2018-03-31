//
//  AppDelegate.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 20/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import DipApplication
import AlamofireNetworkActivityIndicator

typealias LaunchOptions = [UIApplicationLaunchOptionsKey: Any]

class AppDelegate: UIResponder, AppDelegateHandler {

    let mainRouter: LaunchRouter

    init(mainRouter: LaunchRouter) {
        self.mainRouter = mainRouter
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: LaunchOptions?) -> Bool {
        
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0
        NetworkActivityIndicatorManager.shared.completionDelay = 0
        
        mainRouter.openInitialModule()
        return true
    }
}
