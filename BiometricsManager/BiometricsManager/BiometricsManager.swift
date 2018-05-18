//
//  BiometricsManager.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 10/4/17.
//  Copyright © 2017 LifeTech. All rights reserved.
//

import Foundation
import LocalAuthentication

/// !!!!!!!!!!!!!!!! check
///LAError.Code
/// !!!!!!!!!!!!!!!!

typealias AuthenticateHandler = (BiometricsAuthenticateResult) -> Void
typealias AuthenticateHandler2 = (LAError.Code) -> Void

protocol BiometricsManager {
    var isEnabled: Bool { get set }
    var status: BiometricsStatus { get }
    var biometricsTitle: String { get }
    var isAvailableFaceID: Bool { get }
    func authenticate(reason: String, handler: @escaping AuthenticateHandler)
}

// TODO: rewrite to system codes
//public var kLAErrorAuthenticationFailed: Int32 { get }
//public var kLAErrorUserCancel: Int32 { get }
//public var kLAErrorUserFallback: Int32 { get }
//public var kLAErrorSystemCancel: Int32 { get }
//public var kLAErrorPasscodeNotSet: Int32 { get }
//public var kLAErrorTouchIDNotAvailable: Int32 { get }
//public var kLAErrorTouchIDNotEnrolled: Int32 { get }
//public var kLAErrorTouchIDLockout: Int32 { get }
//public var kLAErrorAppCancel: Int32 { get }
//public var kLAErrorInvalidContext: Int32 { get }
//public var kLAErrorNotInteractive: Int32 { get }
//
//public var kLAErrorBiometryNotAvailable: Int32 { get }
//public var kLAErrorBiometryNotEnrolled: Int32 { get }
//public var kLAErrorBiometryLockout: Int32 { get }

enum BiometricsAuthenticateResult: Int {
    case success = 0
    case notAvailable = 1
    case retryLimitReached = -1
    case cancelledByUser = -2
    case cancelledBySystem = -4
    case sensorIsLocked = -8
}

enum BiometricsStatus {
    case available
    case notAvailable
    case notInitialized ///"passcode is enrolled and biometrics not"
}

final class BiometricsManagerImp: BiometricsManager {
    
    static func printErrors() {
//        kLAErrorAuthenticationFailed -1
//        kLAErrorUserCancel -2
//        kLAErrorUserFallback -3
//        kLAErrorSystemCancel -4
//        kLAErrorPasscodeNotSet -5
//        kLAErrorTouchIDNotAvailable -6
//        kLAErrorTouchIDNotEnrolled -7
//        kLAErrorTouchIDLockout -8
//        kLAErrorAppCancel -9
//        kLAErrorInvalidContext -10
//        kLAErrorAuthenticationFailed -1
//        kLAErrorInvalidContext -10
//        kLAErrorNotInteractive -1004 User interaction is required
//        kLAErrorBiometryNotAvailable -6
//        kLAErrorBiometryNotEnrolled -7
//        kLAErrorBiometryLockout -8
        print("kLAErrorAuthenticationFailed", kLAErrorAuthenticationFailed) ///-1
        print("kLAErrorUserCancel", kLAErrorUserCancel) ///-2
        print("kLAErrorUserFallback", kLAErrorUserFallback) ///-3
        print("kLAErrorSystemCancel", kLAErrorSystemCancel) ///-4
        print("kLAErrorPasscodeNotSet", kLAErrorPasscodeNotSet) ///-5
        print("kLAErrorTouchIDNotAvailable", kLAErrorTouchIDNotAvailable) ///-6
        print("kLAErrorTouchIDNotEnrolled", kLAErrorTouchIDNotEnrolled)
        print("kLAErrorTouchIDLockout", kLAErrorTouchIDLockout)
        print("kLAErrorAppCancel", kLAErrorAppCancel)
        print("kLAErrorInvalidContext", kLAErrorInvalidContext)
        print("kLAErrorAuthenticationFailed", kLAErrorAuthenticationFailed)
        print("kLAErrorInvalidContext", kLAErrorInvalidContext)
        
        /// https://stackoverflow.com/questions/29016692/1004-error-code-from-lacontexts-evaluatepolicy-method
        /// https://stackoverflow.com/questions/38854052/touchid-error-code-1004-nslocalizeddescription-user-interaction-is-required
        print("kLAErrorNotInteractive", kLAErrorNotInteractive) ///-1004
        
        print("kLAErrorBiometryNotAvailable", kLAErrorBiometryNotAvailable)
        print("kLAErrorBiometryNotEnrolled", kLAErrorBiometryNotEnrolled)
        print("kLAErrorBiometryLockout", kLAErrorBiometryLockout)
    } 
    
    private lazy var defaults = UserDefaults(suiteName: "groupIdentifier")
    
    private static let isEnabledKey = "BiometricsManagerIsEnabledKey"
    var isEnabled: Bool {
        get { return defaults?.bool(forKey: BiometricsManagerImp.isEnabledKey) ?? false}
        set { defaults?.set(newValue, forKey: BiometricsManagerImp.isEnabledKey) }
    }
    
    var status: BiometricsStatus {
        var error: NSError?
        let result = LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if result {
            return .available
        /// biometrics are available on device, but is not turn on.
        /// -5, -7 hardcoded, not documented constants to detect it.
        /// may not be working for some devices.
        } else if error?.code == -5 || error?.code == -7 {
            return .notInitialized
        } else { /// err.code == -6 no physical equipment
            
            /// System locks Touch ID after 5 invalid tries.
            /// It says: Biometry is locked out. (error?.code == -8)
            /// Will be locked until the user enters the passcode
            /// Solution: Lock-unlock device by turn off screen and Touch ID will be available.
            return .notAvailable
        }
    }
    
    /// maybe will be need
    // TODO: it is work correct
    // TODO: check without BoolHandler
    // TODO: correct all text for Face ID
    /// https://stackoverflow.com/a/45613341/5893286
    /// https://stackoverflow.com/a/40785158/5893286
    func isBiometryReady() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        /// If set to empty string, the button will be hidden
        context.localizedFallbackTitle = ""
        
        if #available(iOS 10.0, *) {
            context.localizedCancelTitle = "Enter Using Passcode"
        }
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        }
        
        var isBiometryReady = false
        if error?.code == -8 {
            let reason = "TouchID has been locked out due to few fail attemp. Enter iPhone passcode to enable touchID."
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { success, error in
                isBiometryReady = false                    
            })
            isBiometryReady = true
        }
        return isBiometryReady
    }

    
    lazy var biometricsTitle: String = {
        isAvailableFaceID ?  "Face ID" : "Touch ID"
    }()
    
    /// You need to first call canEvaluatePolicy in order to get the biometry type.
    /// That is, if you're just doing LAContext().biometryType then you'll always get 'none' back
    /// https://forums.developer.apple.com/thread/89043
    var isAvailableFaceID: Bool {
        return Device.isIphoneX
        /// old normal realization
//        let context = LAContext()
//        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
//            return false
//        }
//        if #available(iOS 11.0, *) {
//            return context.biometryType == .faceID
//        } else {
//            return false
//        }
    }
    
    func authenticate(reason: String = "To enter passcode", handler: @escaping AuthenticateHandler) {
        if status != .available || !isEnabled {
            return handler(.notAvailable)
        }
        
        LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    handler(.success)
                } else if let error = error as NSError? {
                    print("Fingerprint validation failed: \(error.localizedDescription). Code: error.code")
                    if let status = BiometricsAuthenticateResult(rawValue: error.code) {
                        handler(status)
                    } else {
                        handler(.notAvailable)
                    }
                    
                    
                    if let status = LAError.Code(rawValue: error.code) {
                        switch status {
                        case .appCancel:
                            break
                        case .authenticationFailed:
                            break
                        case .userCancel:
                            break
                        case .userFallback:
                            break
                        case .systemCancel:
                            break
                        case .passcodeNotSet:
                            break
                        case .touchIDNotAvailable: ///biometryNotAvailable
                            break
                        case .touchIDNotEnrolled: ///touchIDNotEnrolled
                            break
                        case .touchIDLockout: /// touchIDLockout
                            break
                        case .invalidContext:
                            break
                        case .notInteractive:
                            break
                        }
                    } else {
                            
                        //                        handler(.notAvailable)
                    }
                    
                }
            }
        }
    }
    
//    func authenticate2(reason: String = "To enter passcode", handler: @escaping AuthenticateHandler2) {
//        LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
//            DispatchQueue.main.async {
//                if success {
//                    handler(.success)
//                } else if let error = error as NSError? {
//                    print("Fingerprint validation failed: \(error.localizedDescription). Code: error.code")
//                    if let status = LAError.Code(rawValue: error.code) {
//                        handler(status)
//                    } else {
////                        handler(.notAvailable)
//                    }
//                }
//            }
//        }
//    }
}
