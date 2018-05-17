//
//  ViewController.swift
//  OptIn
//
//  Created by Bondar Yaroslav on 11/28/17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func actionOptInButton(_ sender: UIButton) {
        let vc = OptInController(phone: "+905303171879")
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: OptInControllerDelegate {
    func optInResendPressed(_ optInVC: OptInController) {
        optInVC.startTimer()
    }
    
    func optInReachedMaxAttempts(_ optInVC: OptInController) {
        optInVC.dropTimer()
        optInVC.resendButton.isHidden = false
    }
    
    func optInNavigationTitle() -> String {
        return "Verify"
    }
    
    func optInContorller(_ optInVC: OptInController, didEnterCode code: String) {
        if code == "222222" {
            optInVC.dismissKeyboard()
            dismiss(animated: true, completion: nil)
        } else {
            print("error")
            optInVC.increaseNumberOfAttemps()
            optInVC.clearCode()
        }
        //verify
        
    }
    
    
}

