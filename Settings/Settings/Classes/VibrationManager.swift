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

/// https://developer.apple.com/documentation/uikit/uifeedbackgenerator
/// https://medium.com/@sdrzn/make-your-ios-app-feel-better-a-comprehensive-guide-over-taptic-engine-and-haptic-feedback-724dec425f10
final class VibrationManager {

    static let shared = VibrationManager()
    
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

    func basicVibrate(_ type: BasicViration) {
        AudioServicesPlaySystemSound(type.rawValue)
        //AudioServicesPlaySystemSoundWithCompletion(type.rawValue) {
        //    print("did vibrate")
        //}
    }

    //@available(iOS 10.0, *)
    func hapticVibrate(_ type: HapticViration) {
        //generator.prepare()
        //if #available(iOS 10.0, *) {
        
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
