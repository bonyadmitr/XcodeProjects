//
//  SettingsStorage.swift
//  Settings
//
//  Created by Yaroslav Bondar on 19/11/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol SettingsStorage: VibrationStorage {
    //var isEnabledVibration: Bool { get set }
    func saveIfNeed()
    func resetToDefault()
}

protocol SettingsStorageDelegate {
    func settingsRestoredToDefaults()
}

final class SettingsStorageImp: MulticastHandler {
    
    static let shared = SettingsStorageImp()
    
    private enum Keys {
        private static let base = "SettingsStorageImp_"
        static let isEnabledVibrationKey = base + "isEnabledVibrationKey"
    }
    
    private let defaults = UserDefaults.standard
    
    internal var delegates = MulticastDelegate<SettingsStorageDelegate>()
    
    //    var isEnabledVibration: Bool {
    //        get {
    //            return UserDefaults.standard.bool(forKey: Keys.isEnabledVibrationKey)
    //        }
    //        set {
    //            UserDefaults.standard.set(newValue, forKey: Keys.isEnabledVibrationKey)
    //        }
    //    }
    
    var isEnabledVibration: Bool {
        didSet {
            defaults.set(isEnabledVibration, forKey: Keys.isEnabledVibrationKey)
        }
    }
    
    init() {
        type(of: self).setupDefaultValuesIfNeed()
        //        isEnabledVibration = defaults.object(forKey: Keys.isEnabledVibrationKey) as? Bool ?? DefaultValues.isEnabledVibration
        isEnabledVibration = defaults.bool(forKey: Keys.isEnabledVibrationKey)
    }
    
    private static func setupDefaultValuesIfNeed() {
        UserDefaults.standard.register(defaults: [Keys.isEnabledVibrationKey: true])
    }
}

extension SettingsStorageImp: SettingsStorage {
    func saveIfNeed() {
        defaults.synchronize()
    }
    
    func resetToDefault() {
        defaults.removeObjects(for: [Keys.isEnabledVibrationKey])
        type(of: self).setupDefaultValuesIfNeed()
        delegates.invoke { $0.settingsRestoredToDefaults() }
    }
}
