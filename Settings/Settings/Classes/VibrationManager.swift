//
//  VibrationManager.swift
//  Settings
//
//  Created by Yaroslav Bondar on 18/11/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices

//enum BasicViration: SystemSoundID {
//    case standart = 4095 /// kSystemSoundID_Vibrate
//    case alert = 1011 /// double vibration
//    case light = 1102
//    case silenceMode = 1107 /// like standart but working only in silence mode
//}
//
//enum HapticViration {
//    case error
//    case success
//    case warning
//    case light
//    case medium
//    case heavy
//    case selection
//}
//
//protocol VibrationManager {
//    func basicVibrate(_ type: BasicViration)
//    func hapticVibrate(_ type: HapticViration)
//}
//extension VibrationManager {
//    func basicVibrate(_ type: BasicViration) {
//        AudioServicesPlaySystemSound(type.rawValue)
//        //AudioServicesPlaySystemSoundWithCompletion(type.rawValue) {
//        //    print("did vibrate")
//        //}
//    }
//
//    //@available(iOS 10.0, *)
//    func hapticVibrate(_ type: HapticViration) {
//        //generator.prepare()
//        //if #available(iOS 10.0, *) {
//
//        guard #available(iOS 10.0, *) else {
//            return
//        }
//
//        switch type {
//        case .error:
//            let generator = UINotificationFeedbackGenerator()
//            generator.notificationOccurred(.error)
//
//        case .success:
//            let generator = UINotificationFeedbackGenerator()
//            generator.notificationOccurred(.success)
//
//        case .warning:
//            let generator = UINotificationFeedbackGenerator()
//            generator.notificationOccurred(.warning)
//
//        case .light:
//            let generator = UIImpactFeedbackGenerator(style: .light)
//            generator.impactOccurred()
//
//        case .medium:
//            let generator = UIImpactFeedbackGenerator(style: .medium)
//            generator.impactOccurred()
//
//        case .heavy:
//            let generator = UIImpactFeedbackGenerator(style: .heavy)
//            generator.impactOccurred()
//
//        case .selection:
//            let generator = UISelectionFeedbackGenerator()
//            generator.selectionChanged()
//        }
//    }
//}

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
    
    internal var delegates = MulticastDelegate<SettingsStorageDelegate>()
    
    private enum Keys {
        private static let base = "SettingsStorageImp_"
        static let isEnabledVibrationKey = base + "isEnabledVibrationKey"
    }
    
    private let defaults = UserDefaults.standard
    
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
        isEnabledVibration = defaults.object(forKey: Keys.isEnabledVibrationKey) as? Bool ?? false
        //isEnabledVibration = defaults.bool(forKey: Keys.isEnabledVibrationKey)
    }
}

extension SettingsStorageImp: SettingsStorage {
    func saveIfNeed() {
        defaults.synchronize()
    }
    
    func resetToDefault() {
        isEnabledVibration = false
        delegates.invoke { $0.settingsRestoredToDefaults() }
    }
}

extension String {
    
    /// https://stackoverflow.com/a/31727051/5893286
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}


protocol VibrationStorage {
    var isEnabledVibration: Bool { get set }
}

/// https://developer.apple.com/documentation/uikit/uifeedbackgenerator
/// https://medium.com/@sdrzn/make-your-ios-app-feel-better-a-comprehensive-guide-over-taptic-engine-and-haptic-feedback-724dec425f10
final class VibrationManager {

    static let shared = VibrationManager(vibrationStorage: SettingsStorageImp.shared)
    
    enum BasicViration: SystemSoundID {
        case standart = 4095 /// kSystemSoundID_Vibrate
        case alert = 1011 /// double vibration
        case light = 1102
        case silenceMode = 1107 /// like standart but working only in silence mode
    }

    enum HapticViration {
        case error
        case success
        case warning
        case light
        case medium
        case heavy
        case selection
    }
    
//    private static let isEnabledVibrationKey = "VibrationManager_isEnabledVibrationKey"
//
//    var isEnabledVibration: Bool {
//        get {
//            return UserDefaults.standard.bool(forKey: type(of: self).isEnabledVibrationKey)
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: type(of: self).isEnabledVibrationKey)
//        }
//    }
    
    private let vibrationStorage: VibrationStorage
    
    
    lazy var isAvailableTapticEngine: Bool = {
        #if targetEnvironment(simulator)
        return false
        #else
        
        var sysinfo = utsname()
        uname(&sysinfo)
        let date = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        guard let platform = String(bytes: date, encoding: .ascii)?.trimmingCharacters(in: .controlCharacters),
            let device = platform.slice(from: "iPhone", to: ",") else {
                assertionFailure()
                return false
        }
        /// iPhone6S or iPhone6SPlus
        /// https://gist.github.com/adamawolf/3048717
        
        return platform == "iPhone8,1" || platform == "iPhone8,2"
        #endif
    }()
    
    init(vibrationStorage: VibrationStorage) {
        self.vibrationStorage = vibrationStorage
    }

    func basicVibrate(_ type: BasicViration) {
        guard vibrationStorage.isEnabledVibration else {
            return
        }
        AudioServicesPlaySystemSound(type.rawValue)
        //AudioServicesPlaySystemSoundWithCompletion(type.rawValue) {
        //    print("did vibrate")
        //}
    }

    //@available(iOS 10.0, *)
    /// available iPhone 7...
    func hapticVibrate(_ type: HapticViration) {
        //generator.prepare()
        //if #available(iOS 10.0, *) {
        guard vibrationStorage.isEnabledVibration else {
            return
        }
        guard #available(iOS 10.0, *) else {
            return
        }
        
        switch type {
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)

        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)

        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)

        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()

        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()

        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()

        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}
