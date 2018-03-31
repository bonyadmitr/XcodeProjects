//
//  ViewController.swift
//  JailbreakChecker
//
//  Created by Bondar Yaroslav on 3/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let jailbreakChecker = JailbreakChecker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("isJailbroken:", jailbreakChecker.isJailbroken)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let title = "isJailbroken: \(jailbreakChecker.isJailbroken)"
        let vc = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        vc.addAction(okAction)
        present(vc, animated: true, completion: nil)
    }
}
