//
//  UIViewController+IBAction.swift
//  LocalizationManager
//
//  Created by Bondar Yaroslav on 18/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIViewController {
    @IBAction func dismissSelf(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
