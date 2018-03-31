//
//  SettingsManager.swift
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
/// SettingsManager.shared.setVersion()
/// SettingsManager.shared.registerDefaults()

/// Example: slider update settings in ViewController
/// 1. set slider1.isContinuous = false (can be set in IB) and use 'Value Did Change'
/// 2. or use "Touch Up Inside" and "Touch up outside" action for one func
/// @IBAction func actionSlider(_ sender: UISlider) {
///     UserDefaults.standard.set(sender.value, forKey: SettingsManager.shared.sliderKey)
/// }

/// Manager to control Settings.bundle
class SettingsManager: NSObject {
    
    /// singleton
    static let shared = SettingsManager()
    
    /// key for slider in plist
    let sliderKey = "slider_1"
    
    /// Don't foget init this class for starting observing (can be done with 'func setVersion' in AppDelegate)
    /// If controll didn't chnage default value, UserDefaults will be empty for that key
    override init() {
        super.init()
        
        /// #1
        /// execute code when app become active (sometimes immediately, maybe first time only)
        /// onserve all UserDefaults changes
        /// executed many times at launch bcz of 'setVersion' and others 'UserDefaults.standard.set'
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUserDefaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        
        /// #2
        /// need NSObject subclass
        /// can observe only one key
        /// execute code for any changing in settings
        UserDefaults.standard.addObserver(self, forKeyPath: sliderKey, options: .new, context: nil)
    }
    
    deinit {
        /// #1
        NotificationCenter.default.removeObserver(self)
        /// #2
        UserDefaults.standard.removeObserver(self, forKeyPath: sliderKey)
    }
    
    /// #2
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        /// can be used UserDefaults.standard
        guard let userDefaults = object as? UserDefaults else {
            return print("unknow")
        }
        
        /// 1. option to get changed value
        /// can be filtered by 'keyPath'(keyPath == sliderKey) for different actions and optimization
        let sliderValue = userDefaults.float(forKey: sliderKey)
        print("sliderValue", sliderValue)
        
        /// 2.
        /// change?[.oldKey] is always unavailable
        if let newValue = change?[.newKey] as? Float {
            print("newValue", newValue)
        }
    }
    
    /// #1
    @objc private func notificationUserDefaultsChanged(_ notification:NSNotification) {
        print("--- notificationUserDefaultsChanged")
        
        /// can be used UserDefaults.standard
        guard let userDefaults = notification.object as? UserDefaults else {
            return print("unknow")
        }
        
        /// some king of button. maybe better use switch for button alternative
        /// will call 'func notificationUserDefaultsChanged' bcz of userDefaults.set
        if let clearCache = userDefaults.object(forKey: "clear_cache") as? Bool, clearCache {
            print("cleared")
            /// need to reset value
            userDefaults.set(false, forKey: "clear_cache")
        }
        
        
        /// Examples
        
        let switch1 = userDefaults.bool(forKey: "switch_1")
        print("switch_1", switch1)
        
        if let text_2 = userDefaults.object(forKey: "text_2") as? String {
            print("text_2", text_2)
        }
        
        if let text_1 = userDefaults.object(forKey: "text_1") as? String {
            print("text_1", text_1)
        }
        
        /// can be used:
        /// if let slider_1 = userDefaults.object(forKey: "slider_1") as? Float {
        let slider_1 = userDefaults.float(forKey: "slider_1")
        print("slider_1", slider_1)
        
        if let multi_value = userDefaults.object(forKey: "multi_value") {
            print("multi_value", multi_value)
        }
        
        if let radio_group = userDefaults.object(forKey: "radio_group") {
            print("radio_group", radio_group)
        }
    }
    
    /// To set app version. required UIApplication+Version
    func setVersion() {
        UserDefaults.standard.setValue(UIApplication.shared.version, forKey: "app_version")
    }
    
    /// The Default Value is used by Settings.app for display purposes only.
    /// If you don't change the value in the settings app nothing is saved to UserDefaults
    /// You have to register the default values yourself
    /// You have to synhronize default values in plists and in registration (here)
    func registerDefaults() {
        let settingsDefaults: [String : Any] = [
            "app_author": "Bondar Yaroslav",
            "analytics_enabled": true,
            "text_2": "wwwwww", /// it is not set in plist
            "text_1": "qqqqq", /// it is not set in plist
            "slider_1": 30
        ]
        UserDefaults.standard.register(defaults: settingsDefaults)
    }
    
    /// Some unusual usage
    func sets() {
        /// will set value from Titles for value in Values
        //UserDefaults.standard.set("Some string", forKey: "title_1")
        
        /// needs only for TrueValue/FalseValue keys. For default use 'set bool'
        //UserDefaults.standard.set("Some string", forKey: "switch_1")
    }
}
