//
//  AppDelegate.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

// TODO: default theme
// TODO: apply theme with saving and on launch apply
// TODO: log app started with restoration
// TODO: debug state restoration without xcode (mayby create memory leak)
// TODO: selection color
// TODO: secondaryBackgroundColor
// TODO: secondaryTextColor

/// added main.swift
//@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        LocalizationManager.shared.register(self)
        AppearanceConfigurator.shared.register(self)
//        AppearanceConfigurator.configurate()
        
        AppearanceConfigurator.shared.apply(theme: AppearanceConfigurator.themes[1])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

// MARK: - AppearanceConfiguratorDelegate
extension AppDelegate: AppearanceConfiguratorDelegate {
    func didApplied(theme: AppearanceTheme) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        guard
//            let window = window,
//            let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController,
//            let tabBarControllers = tabBarVC.viewControllers
//            else {
//                assertionFailure()
//                return
//        }
//
//        let lastIndex = tabBarControllers.count - 1
//        tabBarVC.selectedIndex = lastIndex
//
//        guard
//            let settingsSplitVC = tabBarControllers[lastIndex] as? UISplitViewController,
//            let settingsNavVC = settingsSplitVC.viewControllers[0] as? UINavigationController
//            else {
//                assertionFailure()
//                return
//        }
//
//        let settingsVC = settingsNavVC.topViewController as! SettingsController
//        window.rootViewController = tabBarVC
//        settingsVC.performSegue(withIdentifier: "detail!", sender: AppearanceSelectController())
    }
}

// MARK: - UIStateRestoration
extension AppDelegate {
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
}
