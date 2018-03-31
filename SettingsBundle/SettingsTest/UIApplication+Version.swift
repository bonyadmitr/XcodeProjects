//
//  UIApplication+Version.swift
//  SettingsTest
//
//  Created by Bondar Yaroslav on 08/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIApplication {
    
    /// App version number without build number
    /// The value of CFBundleShortVersionString
    var shortVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        /// old version
//        if let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
//            return v
//        }
//        /// guard for future xcode project changes
//        print("info.plist don't contain CFBundleShortVersionString")
    }
    
    /// App build number
    /// The value of CFBundleVersion
    var build: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    /// shortVersion + build
    /// App version contains short version and build numbers. Example: 1.0.1 (1)
    var version: String {
        return "\(shortVersion) (\(build))"
    }
}
