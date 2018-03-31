//
//  UIViewController+Dismiss.swift
//  Transitions
//
//  Created by Bondar Yaroslav on 24/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIViewController {
    @IBAction func dismissSelf(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
