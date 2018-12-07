//
//  Device.swift
//  Settings
//
//  Created by Yaroslav Bondar on 22/11/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

enum Device {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    /// iPhone X, XS, XS Max, XR.
    /// https://stackoverflow.com/a/46227186
    static let isIphoneXOrNewer: Bool = {
        /// 812.0 on iPhone X, XS.
        /// 896.0 on iPhone XS Max, XR.
        return (UIDevice.current.userInterfaceIdiom == .phone) && (UIScreen.main.bounds.height >= 812)
    }()
    
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
