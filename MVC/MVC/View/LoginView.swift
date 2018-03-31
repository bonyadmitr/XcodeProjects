//
//  LoginView.swift
//  MVC
//
//  Created by Bondar Yaroslav on 16/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class LoginView: UIView {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    weak var delegate: LoginViewDelegate?
    
    static func initFromNib() -> LoginView {
        let nibName = String(describing: LoginView.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! LoginView
    }
    
    @IBAction func actionLoginButton(_ sender: UIButton) {
        delegate?.didLogin(email: emailTextField.text!, password: passwordTextField.text!)
    }
}
