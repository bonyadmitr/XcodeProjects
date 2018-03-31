//
//  OrientationManager.swift
//  LandscapeOneController
//
//  Created by Bondar Yaroslav on 12/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// Control device orientation
///
/// Important: add to AppDelegate:
///
/// func application(_ application: UIApplication,
///                  supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
///     return OrientationManager.shared.orientationLock
/// }
///
/// Usage example:
/// OrientationManager.shared.lock(for: [.portrait, .landscapeLeft], rotateTo: .portrait)
///
/// Also look at LandscapeController
///
final class OrientationManager {
    
    /// singlton only usage because of AppDelegate
    static let shared = OrientationManager()
    
    /// you can set any orientation to lock
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    /// lock orientation and force to rotate device
    func lock(for orientation: UIInterfaceOrientationMask, rotateTo rotateOrientation: UIInterfaceOrientation) {
        orientationLock = orientation
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}
