//
//  PasscodeState.swift
//  Passcode
//
//  Created by Bondar Yaroslav on 11/14/17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

enum PasscodeFlow {
    case validate
    case create
    case setNew
    
    var startState: PasscodeState {
        switch self {
        case .validate:
            return ValidatePasscodeState()
        case .create:
            return CreatePasscodeState()
        case .setNew:
            return OldPasscodeState()
        }
    }
}

protocol PasscodeState {
    var title: String { get }
    var isBiometricsAllowed: Bool { get }
    func finish(with passcode: Passcode, manager: PasscodeManager)
}

final class ValidatePasscodeState: PasscodeState {
    let title = TextConstants.passcodeEnter
    let isBiometricsAllowed = true
    
    func finish(with passcode: Passcode, manager: PasscodeManager) {
        if manager.storage.isEqual(to: passcode) {
            manager.storage.numberOfTries = manager.maximumInccorectPasscodeAttempts
            manager.delegate?.passcodeLockDidSucceed(manager)
        } else {
            manager.storage.numberOfTries -= 1
            if manager.storage.numberOfTries <= 0 {
                manager.delegate?.passcodeLockDidFailNumberOfTries(manager)
            }
            
            manager.delegate?.passcodeLockDidFail(manager)
        }
    }
}

final class OldPasscodeState: PasscodeState {
    let title = TextConstants.passcodeEnterOld
    let isBiometricsAllowed = false
    
    func finish(with passcode: Passcode, manager: PasscodeManager) {
        if manager.storage.isEqual(to: passcode) {
            manager.storage.numberOfTries = manager.maximumInccorectPasscodeAttempts
            manager.changeState(to: SetNewPasscodeState())
        } else {
            manager.storage.numberOfTries -= 1
            if manager.storage.numberOfTries <= 0 {
                manager.delegate?.passcodeLockDidFailNumberOfTries(manager)
            }
            
            manager.delegate?.passcodeLockDidFail(manager)
        }
    }
}

class SetNewPasscodeState: PasscodeState {
    let title = TextConstants.passcodeEnterNew
    let isBiometricsAllowed = false
    
    func finish(with passcode: Passcode, manager: PasscodeManager) {
        let state = ConfirmNewPasscodeState(passcode: passcode)
        manager.changeState(to: state)
    }
}

class CreatePasscodeState: SetNewPasscodeState {
    override func finish(with passcode: Passcode, manager: PasscodeManager) {
        let state = ConfirmCreateingNewPasscodeState(passcode: passcode)
        manager.changeState(to: state)
    }
}

class ConfirmNewPasscodeState: PasscodeState {
    let title = TextConstants.passcodeConfirm
    let isBiometricsAllowed = false
    let passcode: Passcode
    
    init(passcode: Passcode) {
        self.passcode = passcode
    }
    
    func finish(with passcode: Passcode, manager: PasscodeManager) {
        if self.passcode == passcode {
            manager.storage.save(passcode: passcode)
            manager.view.passcodeOutput.animateError(with: TextConstants.passcodeChanged)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 ) {
                manager.delegate?.passcodeLockDidSucceed(manager)
            }
            
        } else {
            manager.changeState(to: OldPasscodeState())
            manager.delegate?.passcodeLockDidFail(manager)
        }
    }
}

class ConfirmCreateingNewPasscodeState: ConfirmNewPasscodeState {
    
    #if MAIN_APP
    private lazy var analyticsService: AnalyticsService = factory.resolve()
    #endif
    
    override func finish(with passcode: Passcode, manager: PasscodeManager) {
        if self.passcode == passcode {
            manager.storage.save(passcode: passcode)
            manager.view.passcodeOutput.animateError(with: TextConstants.passcodeSet)
            
            #if MAIN_APP
            analyticsService.track(event: .setPasscode)
            #endif
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 ) {
                manager.delegate?.passcodeLockDidSucceed(manager)
            }
            
        } else {
            manager.changeState(to: CreatePasscodeState())
            manager.delegate?.passcodeLockDidFail(manager)
        }
    }
}
