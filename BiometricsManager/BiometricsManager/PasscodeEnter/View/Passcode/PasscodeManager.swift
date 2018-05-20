//
//  PasscodeFlowManager.swift
//  LifeBox-new
//
//  Created by Bondar Yaroslav on 14/11/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit


protocol PasscodeManager: class {
    var view: PasscodeView { get }
    var storage: PasscodeStorage { get }
    func changeState(to state: PasscodeState)
    var delegate: PasscodeManagerDelegate? { get set }
    func authenticateWithBiometrics()
    var maximumInccorectPasscodeAttempts: Int { get }
    var finishBiometrics: Bool { get set }
    var successFinishBiometrics: Bool { get }
    var userCancelledBiometrics: Bool { get }
}

protocol PasscodeManagerDelegate: class {
    func passcodeLockDidSucceed(_ lock: PasscodeManager)
    func passcodeLockDidFail(_ lock: PasscodeManager)
    func passcodeLockDidFailNumberOfTries(_ lock: PasscodeManager)
}

final class PasscodeManagerImp {
    let view: PasscodeView
    let storage: PasscodeStorage
    var state: PasscodeState
    let biometricsManager: BiometricsManager
    var userCancelledBiometrics = false
    var finishBiometrics = false
    var successFinishBiometrics = false
    
    weak var delegate: PasscodeManagerDelegate?
    
    init(passcodeView: PasscodeView,
         state: PasscodeState,
         passcodeStorage: PasscodeStorage = factory.resolve(),
         biometricsManager: BiometricsManager = factory.resolve()
    ) {
        self.view = passcodeView
        self.storage = passcodeStorage
        self.state = state
        self.biometricsManager = biometricsManager
        passcodeView.passcodeInput.delegate = self
        changeState(to: state)
        initPasscodeStorage()
    }
    
    func initPasscodeStorage() {
        if storage.numberOfTries <= 0 {
            storage.numberOfTries = maximumInccorectPasscodeAttempts
        }
    }
}
extension PasscodeManagerImp: PasscodeManager {
    var maximumInccorectPasscodeAttempts: Int {
        return 5
    }
    
    func changeState(to state: PasscodeState) {
        self.state = state
        view.update(for: state)
        view.passcodeInput.clearPasscode()
        
        if state.isBiometricsAllowed {
            authenticateWithBiometrics()
        }
    }
    
    func authenticateWithBiometrics() {
        if biometricsManager.status != .available || !biometricsManager.isEnabled {
            return
        }
        
        if !canShowBiometrics() {
            return
        }
        
        view.resignResponder()
        
        userCancelledBiometrics = false
        successFinishBiometrics = false
        
        biometricsManager.authenticate(reason: state.title) { status in
            DispatchQueue.main.async {
                switch status {
                case .success:
                    self.view.passcodeInput.animatePasscodeFullEnter()
                    let passcode = self.storage.passcode
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.state.finish(with: passcode, manager: self)
                    }
                    self.finishBiometrics = true
                    self.successFinishBiometrics = true
                    
                case .cancelledByUser:
                    self.userCancelledBiometrics = true
                    self.finishBiometrics = true
            
                case .retryLimitReached:
                    self.finishBiometrics = true
                    
                default: break
                }
                
                if status != .success {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.view.becomeResponder()
                    }
                }
            }
        }
    }
    
    private func canShowBiometrics() -> Bool {
        #if MAIN_APP
        if UIApplication.shared.applicationState != .active {
            return false
        }
        #endif
        
        return !finishBiometrics
    }
}

extension PasscodeManagerImp: PasscodeInputViewDelegate {
    func finish(with passcode: Passcode) {
        state.finish(with: passcode, manager: self)
    }
    func finishErrorAnimation() {
        view.passcodeInput.clearPasscode()
    }
}
