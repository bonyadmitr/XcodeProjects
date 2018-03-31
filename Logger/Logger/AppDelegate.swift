//
//  AppDelegate.swift
//  Logger
//
//  Created by Bondar Yaroslav on 14/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        Logger.shared.configure {
            //            $0.showDate = true
            //            $0.dateFormatter.dateFormat = "MM/dd/yyyy hh:mma"
            
            $0.showThreadName = false
            $0.showFileName = false
            $0.showLineNumber = false
            $0.showFunctionName = false
            
            $0.watchMainThead = true
            
            $0.logRequests = true
            $0.logResponse = true
            $0.logLevel = .none
        }
        
        //        NetworkActivityLogger.shared.level = .debug
        //        NetworkActivityLogger.shared.startLogging()
        
        return true
    }
}

