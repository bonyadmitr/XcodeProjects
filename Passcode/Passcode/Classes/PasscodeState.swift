//
//  PasscodeState.swift
//  Passcode
//
//  Created by Bondar Yaroslav on 11/14/17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol PasscodeState {
    var title: String { get }
    var isBiometricsAllowed: Bool { get }
    func finish(with passcode: Passcode, passcodeInput: PasscodeInput)
}

final class ValidatePasscodeState: PasscodeState {
    let title = "Enter the password"
    let isBiometricsAllowed = true
    
    func finish(with passcode: Passcode, passcodeInput: PasscodeInput) {
        passcodeInput.animateError()
    }
}

final class SetNewPasscodeState: PasscodeState {
    let title = "Enter new password"
    let isBiometricsAllowed = false
    
    func finish(with passcode: Passcode, passcodeInput: PasscodeInput) {
        passcodeInput.clearPasscode()
    }
}



protocol PasscodeLockView {
    var passcodeInput: PasscodeInput { get }
    var passcodeOutput: PasscodeOutput { get }
    func update(for state: PasscodeState) /// with default
}
extension PasscodeLockView {
    func update(for state: PasscodeState) {
        passcodeOutput.text = state.title
    }
}



protocol PasscodeInput: class {
    func clearPasscode()
    func animateError()
    weak var delegate: PasscodeInputViewDelegate? { get set }
}

protocol PasscodeOutput: class {
    var text: String? { get set }
}
extension UILabel: PasscodeOutput {}






final class PasscodeFlowManager {
    let view: PasscodeLockView
    let storage: PasscodeStorage
    
//    var passcode = ""
    
    var state: PasscodeState! {
        didSet {
            view.update(for: state)
        }
    }
    
    init(passcodeView: PasscodeLockView, passcodeStorage: PasscodeStorage = PasscodeStorageDefaults()) {
        self.view = passcodeView
        self.storage = passcodeStorage
        passcodeView.passcodeInput.delegate = self
    }
}
extension PasscodeFlowManager: PasscodeInputViewDelegate {
    func finish(with passcode: Passcode) {
        storage.save(passcode: passcode)
        state.finish(with: passcode, passcodeInput: view.passcodeInput)
//        self.passcode = passcode
//
//        passcodeInputView.clearPasscode()
//        passcodeInputView.animateError()
    }
    func finishErrorAnimation() {
        view.passcodeInput.clearPasscode()
    }
}


final class PasscodeView2: UIView, FromNib {
    
    @IBOutlet private weak var passcodeInputView: PasscodeInputView!
    @IBOutlet private weak var passcodeOutputLabel: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupFromNib()
    }
}
extension PasscodeView2: PasscodeLockView {
    var passcodeOutput: PasscodeOutput {
        return passcodeOutputLabel
    }
    var passcodeInput: PasscodeInput {
        return passcodeInputView
    }
}
