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
extension UINavigationController: UINavigationBarDelegate  {
    /// NOTE: this funcion will be called for all pop actions
    /// https://stackoverflow.com/a/43585267
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        VibrationManager.shared.lightVibrate()
        popVC()
        return true
    }
    
    private func popVC() {
        DispatchQueue.main.async {
            _ = self.popViewController(animated: true)
        }
    }
}

protocol VibrationStorage {
    var isEnabledVibration: Bool { get set }
}

enum Device {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    /// list of platforms https://gist.github.com/adamawolf/3048717
    static let platform: String = {
        var sysinfo = utsname()
        uname(&sysinfo)
        let date = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        
        /// #1
        guard let platform = String(bytes: date, encoding: .ascii)?.trimmingCharacters(in: .controlCharacters) else {
            assertionFailure()
            return "simulator"
        }
        return platform
    }()
    
    static let mainDeviceVersion: Int = {
        guard
            let mainDeviceVersionString = platform.slice(from: "iPhone", to: ","),
            let mainDeviceVersion = Int(mainDeviceVersionString)
        else {
            #if !targetEnvironment(simulator)
            assertionFailure()
            #endif
            return 0
        }
        return mainDeviceVersion
    }()
    
    enum Vibration {
        
        static let type: VibrationType = {
            if isAvailableHapticEngine {
                return .haptic
            } else if isAvailableTapticEngine {
                return .taptic
            } else {
                return .basic
            }
            
            /// private api method
            /// https://stackoverflow.com/a/39592312/5893286
            //if let feedbackSupportLevel = UIDevice.current.value(forKey: "_feedbackSupportLevel") as? Int {
            //    switch feedbackSupportLevel {
            //    case 1:
            //        vibrationType = .taptic
            //    case 2:
            //        vibrationType = .haptic
            //    default:
            //        /// feedbackSupportLevel == 0 for simulator, iPhone SE
            //        vibrationType = .basic
            //    }
            //} else {
            //    assertionFailure()
            //    vibrationType = .basic
            //}
        }()
        
        /// iPhone7 or newer.
        /// there is no for iPad
        private static var isAvailableHapticEngine: Bool {
            return Device.mainDeviceVersion >= 9
        }
        
        /// iPhone 6s, 6s+ only
        private static var isAvailableTapticEngine: Bool {
            return Device.platform == "iPhone8,1" || Device.platform == "iPhone8,2"
        }
    }
}

enum VibrationType {
    /// iPhone7 or newer
    case haptic
    
    /// iPhone 6s, 6s+ only
    case taptic
    
    /// all others
    case basic
}

/// https://github.com/efremidze/Haptica
/// https://developer.apple.com/documentation/uikit/uifeedbackgenerator
/// https://medium.com/@sdrzn/make-your-ios-app-feel-better-a-comprehensive-guide-over-taptic-engine-and-haptic-feedback-724dec425f10
final class VibrationManager {

    static let shared = VibrationManager(vibrationStorage: SettingsStorageImp.shared)
    
    enum BasicVibration: SystemSoundID {
        /// kSystemSoundID_Vibrate. same as 1102
        case standard = 4095
        
        /// double vibration
        case warning = 1011
        
        /// like standart but working only in silence mode. same id in TapticVibration
        case standardSilenceMode = 1107
    }
    
    /// iPhone 6s, 6s+ only
    enum TapticVibration: SystemSoundID {
        /// 1 medium vibrations
        case peek = 1519
        
        /// 1 medium vibrations
        case pop = 1520
        
        /// 2 medium vibrations
        case warning = 1102
        
        /// 3 light vibrations
        case error = 1521
        
        /// 3 medium vibrations but working only in silence mode
        case errorSilenceMode = 1107
    }

    /// iPhone7 or newer
    enum HapticVibration {
        /// 2 fast vibrations
        case success
        
        /// 2 medium fast vibrations
        case warning
        
        /// 3 quickly vibrations
        case error
        
        /// 1 vibration
        case light
        
        /// 1 vibration
        case medium
        
        /// 1 vibration
        case heavy
        
        /// 1 vibration. the lightest one
        case selection
    }
    
    private let vibrationType = Device.Vibration.type
    private let vibrationStorage: VibrationStorage
    
    init(vibrationStorage: VibrationStorage) {
        self.vibrationStorage = vibrationStorage
    }
    
    func lightVibrate() {
        switch vibrationType {
        case .haptic:
            hapticVibrate(.light)
        case .taptic:
            tapticVibrate(.peek)
        case .basic:
            break /// nothing. there is no light basicVibrate
        }
    }
    
    func mediumVibrate() {
        switch vibrationType {
        case .haptic:
            hapticVibrate(.medium)
        case .taptic:
            tapticVibrate(.pop)
        case .basic:
            basicVibrate(.standard)
        }
    }
    
    func doubleVibrate() {
        switch vibrationType {
        case .haptic:
            hapticVibrate(.warning)
        case .taptic:
            tapticVibrate(.warning)
        case .basic:
            basicVibrate(.warning)
        }
    }

    func basicVibrate(_ type: BasicVibration) {
        guard vibrationStorage.isEnabledVibration else {
            return
        }
        AudioServicesPlaySystemSound(type.rawValue)
        //AudioServicesPlaySystemSoundWithCompletion(type.rawValue) {}
    }
    
    func tapticVibrate(_ type: TapticVibration) {
        guard vibrationStorage.isEnabledVibration else {
            return
        }
        AudioServicesPlaySystemSound(type.rawValue)
    }

    /// available iPhone 7 or newer
    func hapticVibrate(_ type: HapticVibration) {
        //generator.prepare()
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
