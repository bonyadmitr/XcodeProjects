//
//  OptInController.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 11/27/17.
//  Copyright © 2017 LifeTech. All rights reserved.
//

import UIKit

protocol OptInControllerDelegate: class {
    func optInNavigationTitle() -> String
    func optInResendPressed(_ optInVC: OptInController)
    func optInContorller(_ optInVC: OptInController, didEnterCode code: String)
    func optInReachedMaxAttempts(_ optInVC: OptInController)
}


final class OptInCustomizator {
    
}

final class OptInController: UIViewController, KeyboardDismissable {
    
    @IBOutlet private weak var codeTextField: CodeTextField!
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var timerLabel: UILabel! {
        didSet {
            timerLabel.setMonospacedDigitFont()
            timerLabel.textColor = UIColor.gray
        }
    }
    
    @IBOutlet weak var resendButton: UIButton! {
        didSet {
//            resendButton.isHidden = true
            resendButton.backgroundColor = UIColor.gray
        }
    }
    
    private lazy var attemptsCounter: AttemptsCounter = InMemoryAttemptsCounter(limit: 5, autoReset: true)
    private lazy var countdownTimer = CountdownTimer()
    
    private let phone: String
    weak var delegate: OptInControllerDelegate?
    
    init(phone: String) {
        self.phone = phone
        super.init(nibName: "OptInController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.phone = ""
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeTextField.becomeFirstResponder()
        titleLabel.text = "Enter the verification code sent to your number \(phone)"
        title = delegate?.optInNavigationTitle()
        startTimer()
//        showIndicator()
//        accountService.info(success: { [weak self] responce in
//            guard let userInfoResponse = responce as? AccountInfoResponse,
//                let number = userInfoResponse.phoneNumber
//                else { return }
//            self?.phone = number
//            DispatchQueue.main.async {
//                self?.hideIndicator()
//            }
//        },  fail: { [weak self] failResponse in
//            DispatchQueue.main.async {
//                self?.hideIndicator()
//            }
//                print(failResponse.description , self?.phone ?? "")
//        })
    }
    
    func startTimer() {
        resendButton.isHidden = true
        attemptsCounter.reset()
        countdownTimer.stop()
        countdownTimer.setup(timeInterval: 1, timerLimit: 100, stepHandler: { [weak self] timeString in
            self?.timerLabel.text = timeString
            }, completion: { [weak self] in
                self?.endEnterCode()
                self?.clearCode()
        })
    }
    
    func dropTimer() {
        countdownTimer.drop()
    }
    
    @IBAction private func changedCodeTextField(_ sender: CodeTextField) {
        if let code = sender.text,
            code.count == sender.characterCountLimit,
            !countdownTimer.isDead
        {
            verify(code: code)
        }
    }
    
    @IBAction private func actionResendButton(_ sender: UIButton) {
        delegate?.optInResendPressed(self)
        codeTextField.isEnabled = true
        codeTextField.becomeFirstResponder()
    }
    
    private func verify(code: String) {
        delegate?.optInContorller(self, didEnterCode: code)
    }
    
    func clearCode() {
        codeTextField.text = ""
    }
    
    func increaseNumberOfAttemps() {
        attemptsCounter.up(limitHandler: { [weak self] in
            guard let `self` = self else {
                return
            }
            self.endEnterCode()
            self.delegate?.optInReachedMaxAttempts(self)
        })
    }
    
    private func endEnterCode() {
        dismissKeyboard()
        codeTextField.isEnabled = false
    }
}
