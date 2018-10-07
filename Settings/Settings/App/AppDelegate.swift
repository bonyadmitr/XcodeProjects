//
//  AppDelegate.swift
//  Settings
//
//  Created by Bondar Yaroslav on 9/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

// TODO: window round coners 
// TODO: swiftgen strings file
// TODO: UIKeyCommand (from SplitController project)
// TODO: UISelectionFeedbackGenerator
// TODO: log JailbreakChecker
// TODO: sounds on tap
// TODO: sounds settings
// TODO: crashlitics?
// TODO: fabric analytics?
// TODO: auto turn on dark theme (Pet Finder_Completed_Swift3 project)
// TODO: for release mode shake to send a bug via email

// TODO: other options in settings:
//
/// Optional:
// Clear cash (mb)
// Collect anonimus statistics
// Passcode
// font size slider
//
/// FAQ (Questions & Answers)
/// More applications
/// Tell a friend (social, email, qr code (QRScanner), More(share with iOS share action) )
/// Software update (new update)
/// About (Help / О приложении):
// Icon
// app version (с билд номером и без него)
// Feedback (Send feedback / Contact Us / Написать автору)
// Social links (buttons)
// Rate Us
// Privacy Policy (Terms and Privacy Policy) (wkwebview)
// Terms of Service
// Lisences (Legal notices) (pods)
// Developer note (about bugs)

// TODO: accessibility
// TODO: restoration scroll offset for large titles
// https://medium.com/bbc-design-engineering/improving-your-apps-accessibility-with-ios-11-db8bb4ee7c9f
// https://developer.apple.com/videos/play/wwdc2017/204/
//
// adopt cell size for large text
// basic cell is normal in basic tableView
// basic cell is NOT normal in GROUPED tableView
//
/// To activate large bar items (navbar nad tabbar items)
/// Settings - General - Accessibility - Large Text
/// or 1: check Larger Accessibility Sizes - move slider right 4 times (for all iPhones)
/// or 2: move slider top right - check Larger Accessibility Sizes - move slider right one more time (for all iPhones)

/// added main.swift
//@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isApplicationRestored = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        #if DEBUG
        Logger.shared.configure {
            $0.showDate = true
            //                        $0.dateFormatter.dateFormat = "MM/dd/yyyy hh:mma"
            
            //            $0.showThreadName = false
            //            $0.showFileName = false
            //            $0.showLineNumber = false
            //            $0.showFunctionName = false
            //            $0.watchMainThead = true
        }
        log("didFinishLaunchingWithOptions -----")
        log("--- isApplicationRestored: \(isApplicationRestored)")
        
        
        /// cmd + ctrl + z
        Floating.mode = .shake
        
        let vc = FloatingPresentingController()
        let navVC = FloatingNavigationController(rootViewController: vc)
        FloatingManager.shared.presentingController = navVC
        #endif
        
        LocalizationManager.shared.register(self)
        
        AppearanceConfigurator.shared.loadSavedTheme()
        SettingsBundleManager.shared.setup()
        
        /// not working
        //application.ignoreSnapshotOnNextApplicationLaunch()
        
        /// Another solution is apple AppearanceConfigurator theme textColor for lables in cells
        /// and subsribe all tableViews for theme did change
        NotificationCenter.default.addObserver(self, selector: #selector(largeTextAccessibilityDidChanged), name: .UIContentSizeCategoryDidChange, object: nil)
        
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
    @objc private func largeTextAccessibilityDidChanged() {

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard
            let window = window,
            let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController
        else {
            assertionFailure()
            return
        }
        
        // TODO: check for any presentedViewController controller
        #if DEBUG
        if let oldVC = window.rootViewController?.presentedViewController as? FloatingNavigationController {
            oldVC.dismiss(animated: false) {
                window.rootViewController = tabBarVC
                Floating.isShownOnShake = false
                let vc = FloatingPresentingController()
                let navVC = FloatingNavigationController(rootViewController: vc)
                FloatingManager.shared.presentingController = navVC
            }
        } else {
            window.rootViewController = tabBarVC
        }
        #else
        window.rootViewController = tabBarVC
        #endif
    }
    
}

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
    
    /// decode any state at the app delegate level
    ///
    /// if you plan to do any asynchronous initialization for restoration -
    /// Use these methods to inform the system that state restoration is occuring
    /// asynchronously after the application has processed its restoration archive on launch.
    /// In the event of a crash, the system will be able to detect that it may have been
    /// caused by a bad restoration archive and arrange to ignore it on a subsequent application launch.
    ///
//    func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
//
//        application.extendStateRestoration()
//
//        DispatchQueue.global().async {
//            /// do any additional asynchronous initialization work here...
//
//            DispatchQueue.main.async {
//                application.completeStateRestoration()
//            }
//        }
//
//        // if you ever want to check for restore bundle version of user interface idiom, use this code:
//        //
//        //ask for the restoration version (used in case we have multiple versions of the app with varying UIs)
//        // String with value of info.plist's Bundle Version (app version) when state was last saved for the app
//        //
//        guard let restoreBundleVersion = coder.decodeObject(forKey: UIApplicationStateRestorationBundleVersionKey) as? String else {
//            return
//        }
//
//        print("Restore bundle version:", restoreBundleVersion)
//
//        // ask for the restoration idiom (used in case user ran used to run an iPhone version but now running on an iPad)
//        // NSNumber containing the UIUSerInterfaceIdiom enum value of the app that saved state
//        //
//        guard let restoreUserInterfaceIdiom = coder.decodeObject(forKey: UIApplicationStateRestorationUserInterfaceIdiomKey) as? NSNumber else {
//            return
//        }
//
//        print("Restore User Interface Idiom:", restoreUserInterfaceIdiom.intValue)
//
//    }
    
    /// note: if you don't assign a restoration class to each view controller,
    /// here we need to implement "viewControllerWithRestorationIdentifierPath"
//    func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
//
//        /// to get our main storyboard
//        guard let storyboard = coder.decodeObject(forKey: UIStateRestorationViewControllerStoryboardKey) as? UIStoryboard else {
//            return nil
//        }
//        return nil
//    }
    
    func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
        NotificationCenter.default.post(name: .willEncodeRestorableState, object: nil)
    }
}

extension NSNotification.Name {
    static let willEncodeRestorableState = NSNotification.Name("custom_willEncodeRestorableState")
}
