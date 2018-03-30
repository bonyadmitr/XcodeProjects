//
//  SettingsBundleManager.swift
//  SettingsTest
//
//  Created by Bondar Yaroslav on 08/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/UserDefaults/Preferences/Preferences.html
/// https://developer.apple.com/library/content/documentation/PreferenceSettings/Conceptual/SettingsApplicationSchemaReference/Introduction/Introduction.html#

/// Bug of iOS. If settings for your app is blank, double-click the home button. Swipe up on the Settings app to kill the process. Start the Settings again.

/// Example usage:
/// SettingsBundleManager.shared.setVersion()
/// SettingsBundleManager.shared.registerDefaults()

/// Example: slider update settings in ViewController
/// 1. set slider1.isContinuous = false (can be set in IB) and use 'Value Did Change'
/// 2. or use "Touch Up Inside" and "Touch up outside" action for one func
/// @IBAction func actionSlider(_ sender: UISlider) {
///     UserDefaults.standard.set(sender.value, forKey: SettingsBundleManager.shared.sliderKey)
/// }

/// Manager to control Settings.bundle
class SettingsBundleManager: NSObject {
    
    /// singleton
    static let shared = SettingsBundleManager()
    
    /// To set app version. required UIApplication+Version
    func setDefaults() {
        UserDefaultsManager.shared.setAppVersion()
        UserDefaultsManager.shared.setAuthor()
    }
    
    /// The Default Value is used by Settings.app for display purposes only.
    /// If you don't change the value in the settings app nothing is saved to UserDefaults
    /// You have to register the default values yourself. ??? for iOS 10.3
    /// ??? You have to synhronize default values in plists and in registration (here)
    private func registerDefaults() {
        let settingsDefaults: [String : Any] = [
            DefaultKeys.appVersion: "",
            DefaultKeys.appAuthor: "",
            DefaultKeys.analyticsEnabled: true
        ]
        UserDefaultsManager.shared.register(defaults: settingsDefaults)
    }
    
    /// key for slider in plist
//    let sliderKey = "slider_1"
    
    /// Don't foget init this class for starting observing (can be done with 'func setVersion' in AppDelegate)
    /// If controll didn't chnage default value, UserDefaults will be empty for that key
    override init() {
        super.init()
        
        /// ??? work without registration
        registerDefaults()
        
        /// #1
        /// execute code when app become active (sometimes immediately, maybe first time only)
        /// onserve all UserDefaults changes
        /// executed many times at launch bcz of 'setVersion' and others 'UserDefaults.standard.set'
//        NotificationCenter.default.addObserver(self, selector: #selector(notificationUserDefaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        
        /// #2
        /// need NSObject subclass
        /// can observe only one key
        /// execute code for any changing in settings
        UserDefaults.standard.addObserver(self, forKeyPath: DefaultKeys.analyticsEnabled, options: .new, context: nil)
    }

    deinit {
        /// #1
//        NotificationCenter.default.removeObserver(self)
        /// #2
        UserDefaults.standard.removeObserver(self, forKeyPath: DefaultKeys.analyticsEnabled)
    }

    // TODO: Check new syntax ! #3
//    func observe<Value>(_ keyPath: KeyPath<SettingsBundleManager, Value>, options: NSKeyValueObservingOptions, changeHandler: @escaping (SettingsBundleManager, NSKeyValueObservedChange<Value>) -> Void) -> NSKeyValueObservation {
//
//    }
    
    /// #2
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        FabricManager.shared.isEnabled = UserDefaultsManager.shared.isAnalyticsEnabled

//        /// 1. option to get changed value
//        /// can be filtered by 'keyPath'(keyPath == sliderKey) for different actions and optimization
//        let sliderValue = UserDefaults.standard.float(forKey: sliderKey)
//        print("sliderValue", sliderValue)
//        
//        /// 2.
//        /// change?[.oldKey] is always unavailable
//        if let newValue = change?[.newKey] as? Float {
//            print("newValue", newValue)
//        }
    }
//
//    /// #1
//    @objc private func notificationUserDefaultsChanged(_ notification: NSNotification) {
//        print("--- notificationUserDefaultsChanged")
//        
//        /// can be used UserDefaults.standard
//        guard let userDefaults = notification.object as? UserDefaults else {
//            return print("unknow")
//        }
//        
//        /// some king of button. maybe better use switch for button alternative
//        /// will call 'func notificationUserDefaultsChanged' bcz of userDefaults.set
//        if let clearCache = userDefaults.object(forKey: "clear_cache") as? Bool, clearCache {
//            print("cleared")
//            /// need to reset value
//            userDefaults.set(false, forKey: "clear_cache")
//        }
//        
//        
//        /// Examples
//        
//        let switch1 = userDefaults.bool(forKey: "switch_1")
//        print("switch_1", switch1)
//        
//        if let text_2 = userDefaults.object(forKey: "text_2") as? String {
//            print("text_2", text_2)
//        }
//        
//        if let text_1 = userDefaults.object(forKey: "text_1") as? String {
//            print("text_1", text_1)
//        }
//        
//        /// can be used:
//        /// if let slider_1 = userDefaults.object(forKey: "slider_1") as? Float {
//        let slider_1 = userDefaults.float(forKey: "slider_1")
//        print("slider_1", slider_1)
//        
//        if let multi_value = userDefaults.object(forKey: "multi_value") {
//            print("multi_value", multi_value)
//        }
//        
//        if let radio_group = userDefaults.object(forKey: "radio_group") {
//            print("radio_group", radio_group)
//        }
//    }
}
