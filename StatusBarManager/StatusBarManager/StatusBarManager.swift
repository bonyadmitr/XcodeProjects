//
//  StatusBarManager.swift
//  StatusBarManager
//
//  Created by Bondar Yaroslav on 07/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final public class StatusBarManager {
    
    private weak var vc: UIViewController?
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    var animationDuration = 0.3
    var updateAnimation = UIStatusBarAnimation.fade
    
    var isHidden = false {
        didSet {
            update()
        }
    }
    
    var style = UIStatusBarStyle.default {
        didSet {
            update()
        }
    }
    
    private func update() {
        if animationDuration == 0 {
            vc?.setNeedsStatusBarAppearanceUpdate()
        } else {
            UIView.animate(withDuration: animationDuration) {
                self.vc?.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
}
