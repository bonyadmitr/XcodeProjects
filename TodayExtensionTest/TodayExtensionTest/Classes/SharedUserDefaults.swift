//
//  SharedUserDefaults.swift
//  TodayExtensionTest
//
//  Created by Bondar Yaroslav on 09/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// Remember: set file for all targets
/// If need fill field from userDefaults like:
/// someLabel.text = SharedUserDefaults.shared.someText
class SharedUserDefaults {
    
    static let shared = SharedUserDefaults()
    
    let userDefaults = UserDefaults(suiteName: "group.by.TodayExtensionTest111q")!
    
    var shownCounter: Int {
        get { return userDefaults.integer(forKey: "shownCounter") }
        set { userDefaults.set(newValue, forKey: "shownCounter") }
    }
    
    var someText: String? {
        get { return userDefaults.string(forKey: "someText") }
        set { userDefaults.set(newValue, forKey: "someText") }
    }
}
