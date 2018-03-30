//
//  ViewController.swift
//  AlternateIcon
//
//  Created by Bondar Yaroslav on 13/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func actionChooseIconButton(_ sender: UIButton) {
        if #available(iOS 10.3, *) {
            AppIconManager.shared.switch(to: .primary) {
                print("success")
            }
        } else {
            print("unavailable. iOS version < 10.3")
        }
    }
}
