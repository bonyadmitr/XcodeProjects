//
//  LoginController.swift
//  InternHelper
//
//  Created by Yaroslav Bondar on 05.07.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import Cocoa
import PromiseKit

class LoginController: NSViewController {

    // MARK: - Properties
    // TODO: Возможно можно сделать поля email и пароля в одном экземляре
    // TODO: но возможно это ухудшит читабельность кода, но сократит переменные и методы
    @IBOutlet weak var loginEmailTextField: NSTextField!
    @IBOutlet weak var loginPasswordTextField: NSSecureTextField!
    
    @IBOutlet weak var fullNameTextField: NSTextField!
    @IBOutlet weak var signUpEmailTextField: NSTextField!
    @IBOutlet weak var signUpPasswordTextField: NSSecureTextField!
    
    let segueIdent = "Timer"

    
    // MARK: - Actions
    @IBAction func actionLoginButton(sender: NSButton) {
        createCredentials().then { credentials -> Promise<OCUser> in
            OCAccountService.credentials = credentials
            return OCAccountService.login()
        }.then { user -> Void in
            OCAccountService.currentUser = user
            print("Success")
            isLogined = true
            let appDelegate = NSApp.delegate as? AppDelegate
            appDelegate?.closePopover(appDelegate)
            appDelegate?.start()
        }.catchAndShow()
    }

    @IBAction func actionSignUpButton(sender: NSButton) {
        //TODO: norm init
        // TODO: Создать нормальный инициализатор и метод аналогично createCredentials()
        let user = OCUser()
        user.fullName = fullNameTextField.stringValue
        user.email = signUpEmailTextField.stringValue
        user.password = signUpPasswordTextField.stringValue
        
        OCAccountService.credentials = OCUserCredentials(email:user.email, password:user.password)
        
        OCAccountService.register(user).then { user -> Promise<OCUser> in
            OCAccountService.currentUser = user
           
            return OCAccountService.login()
        }.then { user -> Void in
            OCAccountService.currentUser = user
            isLogined = true
            let appDelegate = NSApp.delegate as? AppDelegate
            appDelegate?.closePopover(appDelegate)
            appDelegate?.start()
        }.catchAndShow()
    }
    
    // MARK: - Methods
    func createCredentials() -> Promise<OCUserCredentials> {
        // TODO: добавить проверки полей и вывод сообщений ошибки валидации и т.п.
        return Promise(OCUserCredentials(email:loginEmailTextField.stringValue, password:loginPasswordTextField.stringValue))
    }
}

// TODO: Создать отдельные файлы для расширений
// MARK: - Extensions
extension NSViewController {
    func close() {
        if let _ = presentingViewController {
            dismissViewController(self)
        } else {
            view.window?.close()
        }
    }
}


extension Promise {
    func catchAndShow() {
        self.error { (error) in
            if let error = error as? Translatable {
                let alert = NSAlert()
                // TODO: создать раширение с красивым и удобным созданием алертов, аналогично UIAlertView
                alert.alertStyle = .CriticalAlertStyle
                alert.informativeText = "Error"
                alert.messageText = error.translated(locale: NSLocale(localeIdentifier: "EN"))
                alert.runModal()
            }
        }
    }
}
