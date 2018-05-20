//
//  PasscodeLockView.swift
//  LifeBox-new
//
//  Created by Bondar Yaroslav on 14/11/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol PasscodeView {
    var passcodeInput: PasscodeInput { get }
    var passcodeOutput: PasscodeOutput { get }
    func update(for state: PasscodeState) /// with default
    func resignResponder()
    func becomeResponder()
}
extension PasscodeView {
    func update(for state: PasscodeState) {
        passcodeOutput.text = state.title
    }
}


protocol PasscodeInput: class {
    var passcode: Passcode { get set }
    func clearPasscode()
    func animateError()
    var delegate: PasscodeInputViewDelegate? { get set }
    func animatePasscodeFullEnter()
}

protocol PasscodeOutput: class {
    var text: String? { get set }
    func animateError(with text: String)
    func animateError(with numberOfTries: Int)
}
