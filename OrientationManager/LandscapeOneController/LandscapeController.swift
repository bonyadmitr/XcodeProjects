//
//  LandscapeController.swift
//  LandscapeOneController
//
//  Created by Bondar Yaroslav on 12/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// Force only one controller to be at landscape orientation
open class LandscapeController: UIViewController {
    
    /// orientation for one controller
    override open func viewDidLoad() {
        super.viewDidLoad()
        OrientationManager.shared.lock(for: .landscapeLeft, rotateTo: .landscapeLeft)
    }
    
    /// set previous state of orientation or any new one
    override open func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        OrientationManager.shared.lock(for: .portrait, rotateTo: .portrait)
    }
}
