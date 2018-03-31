//
//  VC.swift
//  Passcode
//
//  Created by Bondar Yaroslav on 10/4/17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

let passcodeManager = PasscodeManager()

class VC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passcodeManager.delegate = self
    }
    
    @IBAction func actionShowButton(_ sender: UIButton) {
        let vc = passcodeManager.controller
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension VC: PasscodeViewDelegate {
    func check(passcode: Passcode) -> Bool {
        return true
    }
    func finishSetNew(passcode: Passcode) {
        
    }
    func finishValidate() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "VCPASS") as! VCPASS
        navigationController?.pushViewController(vc, animated: true)
    }


}
extension VC: PasscodeEnterDelegate {
    func finishPasscode() {
//        passcodeManager.hide()
    }
}



import UIKit

class VCPASS: UIViewController {
    
    @IBAction func actionSetSwitch(_ sender: UISwitch) {
        passcodeManager.isOn = sender.isOn
    }
    
    @IBAction func actionSetNewButton(_ sender: UIButton) {
        passcodeManager.show(with: .setNew)
    }
}
