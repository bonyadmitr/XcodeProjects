//
//  LoginViewController.swift
//  MVC
//
//  Created by Bondar Yaroslav on 16/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    required init?(coder aDecoder: NSCoder) { fatalError() }
    override func loadView() { view = view_ }
    //------------ required ------------
    
    let view_: LoginView
    let model: LoginModelController
    
    init(view: LoginView, model: LoginModelController) {
        self.view_ = view
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view_.emailTextField.text = model.loginCredentials.email
        view_.passwordTextField.text = model.loginCredentials.password
        view_.delegate = self
    }
}

extension LoginViewController: LoginViewDelegate {
    func didLogin(email: String, password: String) {
        model.loginWith(email: email, password: password) { (isLoggedIn) in
            if isLoggedIn {
                print("Success")
                print("email:", model.loginCredentials.email)
                print("password:", model.loginCredentials.password)
                //present(MainVC, animated: true, completion: nil)
            } else {
                print("Error")
                //present(ErrorPopUp, animated: true, completion: nil)
            }
        }
    }
}
