//
//  StatusBarController.swift
//  StatusBarManager
//
//  Created by Bondar Yaroslav on 07/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

open class StatusBarController: UIViewController {
    
    public final lazy var statusBarManager = StatusBarManager(vc: self)
    
    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return statusBarManager.updateAnimation
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarManager.style
    }
    
    override open var prefersStatusBarHidden: Bool {
        return statusBarManager.isHidden
    }
}
