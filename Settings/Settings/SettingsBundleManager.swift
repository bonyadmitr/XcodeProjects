//
//  SettingsBundleManager.swift
//  Settings
//
//  Created by Bondar Yaroslav on 10/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/UserDefaults/Preferences/Preferences.html
/// https://developer.apple.com/library/content/documentation/PreferenceSettings/Conceptual/SettingsApplicationSchemaReference/Introduction/Introduction.html#

/// Bug of iOS. If settings for your app is blank, double-click the home button. Swipe up on the Settings app to kill the process. Start the Settings again.

final class SettingsBundleManager {
    
    static let shared = SettingsBundleManager()
    
    func setup() {
        setVersion()
    }
    
    private func setVersion() {   
        UserDefaults.standard.set(UIApplication.shared.version, forKey: "version_preference")
    }
}
