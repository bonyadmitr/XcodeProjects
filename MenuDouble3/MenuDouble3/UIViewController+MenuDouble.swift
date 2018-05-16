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
        guard let menuVC = menuDoubleController else { return }
        menuVC.openRightMenu()
    }
    
    var menuDoubleController: MenuDoubleController? {
        var vc = parent
        while vc != nil {
            if vc is MenuDoubleController { break }
            vc = vc?.parent
        }
        guard let menuVC = vc as? MenuDoubleController else {
            return nil
        }
        return menuVC
    }
}
