//
//  UIViewController+MenuDouble.swift
//  MenuDouble
//
//  Created by Bondar Yaroslav on 14/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    @IBAction func toggleMenu(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}
