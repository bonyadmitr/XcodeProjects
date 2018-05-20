//
//  PasscodeView2.swift
//  LifeBox-new
//
//  Created by Bondar Yaroslav on 14/11/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class PasscodeViewImp: UIView, FromNib {
    
    @IBOutlet private weak var passcodeInputView: PasscodeInputView!
    
    @IBOutlet private weak var passcodeOutputLabel: UILabel! {
        didSet {
            passcodeOutputLabel.font = UIFont.TurkcellSaturaRegFont(size: 18)
            passcodeOutputLabel.textColor = ColorConstants.textGrayColor
        }
    }
    
    @IBOutlet weak var passcodeErrorLabel: UILabel! {
        didSet {
            passcodeErrorLabel.font = UIFont.TurkcellSaturaRegFont(size: 18)
            passcodeErrorLabel.backgroundColor = UIColor.darkGray
            passcodeErrorLabel.textColor = UIColor.white
            passcodeErrorLabel.layer.cornerRadius = 5
            passcodeErrorLabel.layer.masksToBounds = true
        }
    }
    
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
        passcodeInputView.becomeFirstResponder()
    }
    
    lazy var passcodeOutput: PasscodeOutput = {
        let po = PasscodeOutputImp()
        po.passcodeErrorLabel = passcodeErrorLabel
        po.passcodeOutputLabel = passcodeOutputLabel
        return po
    }()
}
extension PasscodeViewImp: PasscodeView {
    func becomeResponder() {
        passcodeInputView.becomeFirstResponder()
    }
    
    func resignResponder() {
        passcodeInputView.resignFirstResponder()
    }
    
    var passcodeInput: PasscodeInput {
        return passcodeInputView
    }
}

final class PasscodeOutputImp: PasscodeOutput {
    
    var passcodeOutputLabel: UILabel!
    var passcodeErrorLabel: UILabel!
    
    var text: String? {
        didSet {
            passcodeOutputLabel.text = text
        }
    }
    
    func animateError(with numberOfTries: Int) {
        let text = String(format: TextConstants.passcodeNumberOfTries, numberOfTries.description)
        animateError(with: text)
    }
    
    func animateError(with text: String) {
        
        self.passcodeErrorLabel.alpha = 0
        UIView.animate(withDuration: NumericConstants.animationDuration) {
            self.passcodeErrorLabel.alpha = 1
        }
        
        passcodeErrorLabel.text = text
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: NumericConstants.animationDuration) {
                self.passcodeErrorLabel.alpha = 0
            }
        }
    }
}
