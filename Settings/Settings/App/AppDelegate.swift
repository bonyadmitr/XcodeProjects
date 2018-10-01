//
//  AppDelegate.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

// TODO: swiftgen strings file
// TODO: debug state restoration without xcode (mayby create memory leak)
// TODO: iPhone+ lanscape settings initial state
// TODO: UIKeyCommand (from SplitController project)

/// added main.swift
//@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isApplicationRestored = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print("--- isApplicationRestored: ", isApplicationRestored)
        
        LocalizationManager.shared.register(self)
        AppearanceConfigurator.shared.loadSavedTheme()
        
        /// not working
        //application.ignoreSnapshotOnNextApplicationLaunch()
        
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
///
/// https://github.com/shagedorn/StateRestorationDemo/blob/master/Presentation/State%20Restoration.md
/*
 Unless these methods return YES, the application's state is not saved/restored, no
 matter what you do elsewhere. Consider it a global switch.
 You might want to return `false` conditionally in application(_:shouldRestoreApplicationState:)
 after app updates that include changes to the view (controller) hierarchy and other, potentially
 restoration-breaking changes.
 Returning `true` in application(_:shouldSaveApplicationState:) will create a restoration
 archive ("data.data") which you can inspect using the `restorationArchiveTool` provided by Apple:
 https://developer.apple.com/downloads/ (Login required; search for "restoration")
 Opting into state restoration will also take a snapshot of your app when entering
 background mode.
 While this generally switches on restoration, it doesn't do much yet: Individual
 controllers, views, and other participating objects must implement basic saving/
 restoration mechanisms in order for anything to actually restore. This can be
 done in code, or with the help of Storyboards. This demo focusses on code.
 
 General debugging tips:
 To get the app to restore in the simulator, follow these steps:
 - send the app to the background (home button / cmd + h)
 - quit the app in Xcode
 - relaunch the app
 
 Do not force-quit the app in the app switcher - this deletes the restoration archive.
 Do not kill the app while still in the foreground, as the restoration archive is created
 when the app goes into the background. To debug state restoration on device, read the
 documentation provided with the `restorationArchiveTool` mentioned above.
 */
extension AppDelegate {
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        /// to see path to restoration file: data.data
        let lib = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("Saved Application State")
        print("Restoration files: \(lib.path)")
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
