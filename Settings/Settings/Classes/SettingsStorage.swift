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
    
    private let userDefaults: UserDefaults
    
    internal var delegates = MulticastDelegate<SettingsStorageDelegate>()
    
    //    var isEnabledVibration: Bool {
    //        get {
    //            return UserDefaults.standard.bool(forKey: Keys.isEnabledVibrationKey)
    //        }
    //        set {
    //            UserDefaults.standard.set(newValue, forKey: Keys.isEnabledVibrationKey)
    //        }
    //    }
    
    var isEnabledVibration: Bool = false {
        didSet {
            userDefaults.set(isEnabledVibration, forKey: Keys.isEnabledVibrationKey)
        }
    }
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        registerDefaultValues()
        setupDefaultValues()
    }

    private func registerDefaultValues() {
        userDefaults.register(defaults: [Keys.isEnabledVibrationKey: true])
    }
    
    func setupDefaultValues() {
        //isEnabledVibration = userDefaults.object(forKey: Keys.isEnabledVibrationKey) as? Bool ?? true
        isEnabledVibration = userDefaults.bool(forKey: Keys.isEnabledVibrationKey)
    }
}

extension SettingsStorageImp: SettingsStorage {
    func saveIfNeed() {
        userDefaults.synchronize()
    }
    
    func resetToDefault() {
        userDefaults.removeObjects(for: [Keys.isEnabledVibrationKey])
        registerDefaultValues()
        setupDefaultValues()
        delegates.invoke { $0.settingsRestoredToDefaults() }
    }
}
