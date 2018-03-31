//
//  PasscodeView.swift
//  Passcode
//
//  Created by Bondar Yaroslav on 10/2/17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class PasscodeView: UIView, FromNib {
    
    @IBOutlet private weak var passcodeInputView: PasscodeInputView!
    @IBOutlet private weak var passcodeOutputLabel: UILabel!
    
    var type = PasscodeInputViewType.validate
    
    func set(type: PasscodeInputViewType) {
        self.type = type
        switch type {
        case .new:
            passcodeOutputLabel.text = "Set password"
        case .validate:
            passcodeOutputLabel.text = "Enter the password"
        case .validateNew:
            break /// nothing here
        case .setNew:
            passcodeOutputLabel.text = "Enter old password"
        }
    }
    
    weak var delegate: PasscodeViewDelegate?
    
    private var passcode: Passcode = ""
    
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
        passcodeInputView.delegate = self
        passcodeOutputLabel.text = "Enter new password"
    }
}

extension PasscodeView: PasscodeInputViewDelegate {
    func finish(with passcode: Passcode) {
        switch type {
        case .new:
            self.passcode = passcode
            passcodeInputView.clearPasscode()
            passcodeOutputLabel.text = "Repeat password"
            type = .validateNew
            
        case .validateNew:
            if self.passcode == passcode {
                passcodeInputView.clearPasscode()
                passcodeOutputLabel.text = "Good"
                delegate?.finishSetNew(passcode: passcode)
                /// FINISH
                
            } else {
                passcodeInputView.animateError()
                passcodeOutputLabel.text = "Wrong password. Enter new password again"
                type = .new
            }
            
        case .validate:
            if delegate?.check(passcode: passcode) ?? false {
                passcodeInputView.clearPasscode()
                passcodeOutputLabel.text = "Good"
                delegate?.finishValidate()
                /// FINISH
            } else {
                passcodeInputView.animateError()
                passcodeOutputLabel.text = "Wrong password"
            }
        case .setNew:
            if delegate?.check(passcode: passcode) ?? false {
                passcodeInputView.clearPasscode()
                passcodeOutputLabel.text = "Enter new Password"
                type = .new
                
            } else {
                passcodeInputView.animateError()
                passcodeOutputLabel.text = "Wrong password"
            }
        }
    }
    
    func finishErrorAnimation() {
        passcodeInputView.clearPasscode()
    }
}

protocol PasscodeViewDelegate: class {
    func check(passcode: Passcode) -> Bool
    func finishSetNew(passcode: Passcode)
    func finishValidate()
}
extension PasscodeViewDelegate {
    func finishValidate() {}
    func finishSetNew(passcode: Passcode) {}
}
