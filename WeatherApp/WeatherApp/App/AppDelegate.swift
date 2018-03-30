//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 29/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import GooglePlaces
import AlamofireNetworkActivityIndicator
import RealmSwift

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
        
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0
        NetworkActivityIndicatorManager.shared.completionDelay = 0
        
        GMSPlacesClient.provideAPIKey(URLs.googlePlacesKey)
        FabricManager.shared.startCrashlytics()
        
        AppearanceManager.shared.configurateAll()
        AppearanceManager.shared.configureLocalizedAppearance()
        
        SettingsBundleManager.shared.setDefaults()
        
        configRealm()
        
        return true
    }
    
    func restart() {
        guard let window = window else { return }
        AppearanceManager.shared.configureLocalizedAppearance()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window.rootViewController = storyboard.instantiateViewController(withIdentifier: "startVC")
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {}, completion: nil)
    }
    
    private func configRealm() {
        let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = configuration
        Logger.shared.printRealmFilePath()
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    func applicationWillTerminate(_ application: UIApplication) {
    }
}
