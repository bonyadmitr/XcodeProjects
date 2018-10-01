//
//  AppDelegate.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

// TODO: log app started with restoration
// TODO: debug state restoration without xcode (mayby create memory leak)
// TODO: iPhone+ lanscape settings initial state

/// added main.swift
//@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isApplicationRestored = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print("--- isApplicationRestored: ", isApplicationRestored)
        
        LocalizationManager.shared.register(self)
        AppearanceConfigurator.shared.loadSavedTheme()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    /// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.synchronize()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.synchronize()
    }

}

// MARK: - LocalizationManagerDelegate
extension AppDelegate: LocalizationManagerDelegate {
    func languageDidChange(to language: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard
            let window = window,
            let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController,
            let tabBarControllers = tabBarVC.viewControllers
        else {
            assertionFailure()
            return
        }
        
        let lastIndex = tabBarControllers.count - 1
        tabBarVC.selectedIndex = lastIndex
        
        guard
            let settingsSplitVC = tabBarControllers[lastIndex] as? UISplitViewController,
            let settingsNavVC = settingsSplitVC.viewControllers[0] as? UINavigationController
        else {
            assertionFailure()
            return
        }
        
        let settingsVC = settingsNavVC.topViewController as! SettingsController
        
        
//        guard let settingsNavVC = tabBarControllers[lastIndex] as? UINavigationController else {
//            assertionFailure()
//            return
//        }
        
//        let vc = LanguageSelectController()
        
        /// need bcz of iOS 10 bug with back button
//        if ProcessInfo().operatingSystemVersion.majorVersion == 10 {
//            settingsNavVC.pushViewController(vc, animated: true)
//        } else {
//            settingsNavVC.pushViewController(vc, animated: false)
//        }
        
        window.rootViewController = tabBarVC
        
        /// call after window.rootViewController =
        settingsVC.performSegue(withIdentifier: "detail!", sender: LanguageSelectController())
        
//        animateReload(for: window)
    }
    
    private func animateReload(for window: UIWindow) {
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
        }, completion: nil)
    }
}

// MARK: - UIStateRestoration
extension AppDelegate {
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        isApplicationRestored = true
        return true
    }
    
    /// another methods
//    func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
//        return nil
//    }
//    func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
//    }
//    func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
//    }
}
