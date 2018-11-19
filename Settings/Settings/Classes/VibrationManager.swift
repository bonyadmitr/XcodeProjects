//
//  VibrationManager.swift
//  Settings
//
//  Created by Yaroslav Bondar on 18/11/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices

extension UserDefaults {
    func removeObjects(for keys: [String]) {
        keys.forEach { removeObject(forKey: $0) }
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
    
    enum BasicVibration: SystemSoundID {
        case standart = 4095 /// kSystemSoundID_Vibrate. same as 1102
        case warning = 1011 /// double vibration
        case standartSilenceMode = 1107 /// like standart but working only in silence mode. same id in TapticVibration
    }
    
    enum TapticVibration: SystemSoundID {
        case peek = 1519 /// 1 medium vibrations
        case pop = 1520 /// 1 medium vibrations
        case warning = 1102 /// 2 medium vibrations
        case error = 1521 /// 3 light vibrations
        case errorSilenceMode = 1107 /// 3 medium vibrations but working only in silence mode
    }

    enum HapticVibration {
        case success /// 2 fast vibrations
        case warning /// 2 medium fast vibrations
        case error /// 3 quickly vibrations
        case light /// 1 vibration
        case medium /// 1 vibration
        case heavy /// 1 vibration
        case selection /// 1 vibration. the lightest one
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
    
    
    // there is no for iPad
    lazy var isAvailableTapticEngine: Bool = {
        #if targetEnvironment(simulator)
        return false
        #else
        
        var sysinfo = utsname()
        uname(&sysinfo)
        let date = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        
        /// #1
        guard
            let platform = String(bytes: date, encoding: .ascii)?.trimmingCharacters(in: .controlCharacters),
            let mainDeviceVersionString = platform.slice(from: "iPhone", to: ","),
            let mainDeviceVersion = Int(mainDeviceVersionString)
        else {
            assertionFailure()
            return false
        }
        /// #2
//        guard let platform = String(bytes: date, encoding: .ascii)?.trimmingCharacters(in: .controlCharacters) else {
//            assertionFailure()
//            return false
//        }
        
        /// list of platforms https://gist.github.com/adamawolf/3048717
        /// https://gist.github.com/adamawolf/3048717
        
        /// #1
        return platform == "iPhone8,1" || platform == "iPhone8,2" || mainDeviceVersion >= 9
        /// #2
        //return platform == "iPhone8,1" || platform == "iPhone8,2"
        #endif
    }()
    
    // there is no for iPad
    /// check https://stackoverflow.com/a/42057620/5893286
    /// UIDevice.currentDevice().valueForKey("_feedbackSupportLevel")
    lazy var isAvailableHapticEngine: Bool = {
        #if targetEnvironment(simulator)
        return false
        #else
        
        var sysinfo = utsname()
        uname(&sysinfo)
        let date = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        guard
            let platform = String(bytes: date, encoding: .ascii)?.trimmingCharacters(in: .controlCharacters),
            let mainDeviceVersionString = platform.slice(from: "iPhone", to: ","),
            let mainDeviceVersion = Int(mainDeviceVersionString)
        else {
            assertionFailure()
            return false
        }
        /// iPhone7...
        /// list of platforms https://gist.github.com/adamawolf/3048717
        return mainDeviceVersion >= 9
        #endif
    }()
    
    init(vibrationStorage: VibrationStorage) {
        self.vibrationStorage = vibrationStorage
        
        /// private api method
        /// https://stackoverflow.com/a/39592312/5893286
        //if let feedbackSupportLevel = UIDevice.current.value(forKey: "_feedbackSupportLevel") as? Int {
        //    switch feedbackSupportLevel {
        //    case 1:
        //        print("TapticEngine")
        //    case 2:
        //        print("HapticEngine")
        //    default:
        //        /// feedbackSupportLevel == 0 for simulator, iPhone SE
        //        print("feedbackSupportLevel: ",feedbackSupportLevel)
        //        print("other")
        //    }
        //}
    }
    
    func lightVibrate() {
        if isAvailableHapticEngine {
            hapticVibrate(.selection)
        } else if isAvailableTapticEngine {
            tapticVibrate(.peek)
        } else {
            /// nothing. there is no light basicVibrate
        }
    }
    
    func mediumVibrate() {
        if isAvailableHapticEngine {
            hapticVibrate(.medium)
        } else if isAvailableTapticEngine {
            tapticVibrate(.pop)
        } else {
            basicVibrate(.standart)
        }
    }
    
    func doubleVibrate() {
        if isAvailableHapticEngine {
            hapticVibrate(.warning)
        } else if isAvailableTapticEngine {
            tapticVibrate(.warning)
        } else {
            basicVibrate(.warning)
        }
    }

    func basicVibrate(_ type: BasicVibration) {
        guard vibrationStorage.isEnabledVibration else {
            return
        }
        AudioServicesPlaySystemSound(type.rawValue)
        //AudioServicesPlaySystemSoundWithCompletion(type.rawValue) {
        //    print("did vibrate")
        //}
    }
    
    func tapticVibrate(_ type: TapticVibration) {
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
    func hapticVibrate(_ type: HapticVibration) {
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
