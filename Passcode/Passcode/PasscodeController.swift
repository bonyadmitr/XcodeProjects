//
//  ViewController.swift
//  Passcode
//
//  Created by Bondar Yaroslav on 10/2/17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class PasscodeController: UIViewController {
    
    @IBOutlet weak var passcodeView: PasscodeView!
    
    weak var delegate: PasscodeViewDelegate?
    
    var type = PasscodeInputViewType.validate {
        didSet {
            if passcodeView != nil {
                passcodeView.set(type: type)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passcodeView.set(type: type)
        passcodeView.delegate = delegate
    }
}

class PasscodeController2: UIViewController {
    
    @IBOutlet weak var passcodeView: PasscodeView2!
    
    var passcodeFlowManager: PasscodeFlowManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passcodeFlowManager = PasscodeFlowManager(passcodeView: passcodeView)
    }
}
