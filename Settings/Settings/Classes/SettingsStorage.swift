//
//  SettingsStorage.swift
//  Settings
//
//  Created by Yaroslav Bondar on 19/11/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol SettingsStorage: VibrationStorage, SoundStorage {
    //var isEnabledVibration: Bool { get set }
    func saveIfNeed()
    func resetToDefault()
    func register(_ delegate: SettingsStorageDelegate)
    func unregister(_ delegate: SettingsStorageDelegate)
}

protocol VibrationStorage {
    var isEnabledVibration: Bool { get set }
}

protocol SoundStorage {
    var isEnabledSounds: Bool { get set }
}

protocol SettingsStorageDelegate {
    func settingsRestoredToDefaults()
}

final class SettingsStorageImp: MulticastHandler {
    
    static let shared = SettingsStorageImp()
    
    private enum Keys {
        private static let base = "SettingsStorageImp_"
        static let isEnabledVibration = base + "isEnabledVibration"
        static let isEnabledSounds = base + "isEnabledSounds"
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
            userDefaults.set(isEnabledVibration, forKey: Keys.isEnabledVibration)
        }
    }
    
    var isEnabledSounds: Bool = false {
        didSet {
            userDefaults.set(isEnabledVibration, forKey: Keys.isEnabledSounds)
        }
    }
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        registerDefaultValues()
        setupDefaultValues()
    }

    private func registerDefaultValues() {
        /// turn off basic vibration by default
        let isVibrationOn = Device.Vibration.type == .haptic || Device.Vibration.type == .taptic
        userDefaults.register(defaults: [Keys.isEnabledVibration: isVibrationOn])
    }
    
    func setupDefaultValues() {
        //isEnabledVibration = userDefaults.object(forKey: Keys.isEnabledVibrationKey) as? Bool ?? true
        isEnabledVibration = userDefaults.bool(forKey: Keys.isEnabledVibration)
        isEnabledSounds = userDefaults.bool(forKey: Keys.isEnabledSounds)
    }
}

extension SettingsStorageImp: SettingsStorage {
    func saveIfNeed() {
        userDefaults.synchronize()
    }
    
    func resetToDefault() {
        userDefaults.removeObjects(for: [Keys.isEnabledVibration, Keys.isEnabledSounds])
        registerDefaultValues()
        setupDefaultValues()
        delegates.invoke { $0.settingsRestoredToDefaults() }
    }
}
