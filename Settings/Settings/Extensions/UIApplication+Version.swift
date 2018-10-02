//
//  UIApplication+Version.swift
//  Settings
//
//  Created by Bondar Yaroslav on 10/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//


import UIKit

extension UIApplication {
    
    /// App version number without build number
    /// The value of CFBundleShortVersionString
    var shortVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
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
