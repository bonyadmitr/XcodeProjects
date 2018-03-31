//
//  ViewController.swift
//  LandscapeOneController
//
//  Created by Bondar Yaroslav on 12/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: LandscapeController {
    
    @IBAction func actionExitButton(_ sender: UIButton) {
        if let vc = navigationController {
            vc.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
