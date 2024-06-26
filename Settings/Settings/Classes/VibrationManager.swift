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
extension UINavigationController: UINavigationBarDelegate {
    /// NOTE: this funcion will be called for all pop actions
    /// https://stackoverflow.com/a/43585267
    /// https://gist.github.com/HamGuy/a099058e674b573ffe433132f7b5651e
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        guard let items = navigationBar.items else {
            assertionFailure()
            return false
        }
        
        /// if there is splitViewController and pushes more then 2 (2 + 1 base item >= 3)
        let viewControllersCount = (splitViewController?.isCollapsed == true && items.count >= 3) ? viewControllers.count + 1 : viewControllers.count
        /// #2
//        let viewControllersCount: Int
//        if let splitVC = splitViewController, splitVC.isCollapsed, items.count >= 3 {
//            viewControllersCount = viewControllers.count + 1
//        } else {
//            viewControllersCount = viewControllers.count
//        }
        
        /// will be called twice
        /// second one falls in this case
        if viewControllersCount < items.count {
            return true
        }
        
        VibrationManager.shared.lightVibrate()
        SoundManager.shared.playTapSound()
        popVC()
        return false
    }
    
    private func popVC() {
        DispatchQueue.main.async {
            self.popViewController(animated: true)
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

final class SoundManager {
    
    public enum AlertTone: SystemSoundID {
        case note = 1375
        case aurora = 1366
        case bamboo = 1361
        case chord = 1312
        case circles = 1368
        case complete = 1362
        case hello = 1363
        case input = 1369
        case keys = 1367
        case popcorn = 1364
        case pulse = 1120
        case synth = 1365
        case alert = 1005
        case anticipate = 1020
        case bell = 1013
        case bloom = 1021
        case calypso = 1022
        case chime = 1008
        case choochoo = 1023
        case descent = 1024
        case ding = 1000
        case electronic = 1014
        case fanfare = 1025
        case glass = 1009
        case horn = 1010
        case ladder = 1026
        case minuet = 1027
        case newsflash = 1028
        case noir = 1029
        case sherwoodforest = 1030
        case spell = 1031
        case suspence = 1032
        case swish = 1018
        case swoosh = 1001
        case telegraph = 1033
        case tiptoes = 1034
        case tritone = 1002
        case tweet = 1016
        case typewriters = 1035
        case update = 1036
        case tap = 1104
    }
    
    static let shared = SoundManager(soundStorage: SettingsStorageImp.shared)
    
    private let soundStorage: SoundStorage
    
    init(soundStorage: SoundStorage) {
        self.soundStorage = soundStorage
    }
    
    func play(_ sound: AlertTone) {
        guard soundStorage.isEnabledSounds else {
            return
        }
        AudioServicesPlaySystemSound(sound.rawValue)
    }
    
    func playTapSound() {
        play(.tap)
    }
}
