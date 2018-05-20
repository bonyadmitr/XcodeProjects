//
//  PasscodeEnterPasscodeEnterViewController.swift
//  Depo
//
//  Created by Yaroslav Bondar on 02/10/2017.
//  Copyright © 2017 LifeTech. All rights reserved.
//

import UIKit



class PasscodeEnterViewController: ViewController, NibInit {
    
    static func with(flow: PasscodeFlow, navigationTitle: String) -> PasscodeEnterViewController {
        let vc = PasscodeEnterViewController.initFromNib()
        vc.state = flow.startState
        vc.navigationTitle = navigationTitle
        return vc
    }
    
    @IBOutlet weak var passcodeViewImp: PasscodeViewImp!
    
    private let wormholePoster = WormholePoster()
    
    lazy var passcodeManager: PasscodeManager = {
        loadViewIfNeeded()
        let passcodeManager = PasscodeManagerImp(passcodeView: passcodeViewImp, state: state) 
        passcodeManager.delegate = self
        return passcodeManager
    }()
    
    var state: PasscodeState = ValidatePasscodeState()
    var navigationTitle = ""
    var success: VoidHandler?
    var isTurkCellUser: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passcodeManager.delegate = self
        setTitle(withString: navigationTitle)
    }

    func becomeResponder() {
        passcodeManager.view.becomeResponder()
    }
}

// MARK: PasscodeEnterViewInput
extension PasscodeEnterViewController: PasscodeManagerDelegate {
    func passcodeLockDidFailNumberOfTries(_ lock: PasscodeManager) {
        view.window?.endEditing(true)
        passcodeManager.storage.numberOfTries = passcodeManager.maximumInccorectPasscodeAttempts
        wormholePoster.logout()
    }
    
    func passcodeLockDidSucceed(_ lock: PasscodeManager) {
        passcodeManager.finishBiometrics = true
        lock.view.resignResponder()
        success?()
        if let unwrapedUserFlag = isTurkCellUser, unwrapedUserFlag {
            wormholePoster.offTurkcellPassword()
        }
    }
    
    func passcodeLockDidFail(_ lock: PasscodeManager) {
        lock.view.passcodeInput.animateError()
        if lock.storage.numberOfTries != lock.maximumInccorectPasscodeAttempts {
            lock.view.passcodeOutput.animateError(with: lock.storage.numberOfTries)
        } else {
            lock.view.passcodeOutput.animateError(with: TextConstants.passcodeDontMatch)
        }
    }
}
