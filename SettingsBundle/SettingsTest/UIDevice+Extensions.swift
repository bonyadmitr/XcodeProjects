//
//  UIDevice+Extensions.swift
//  SettingsTest
//
//  Created by Bondar Yaroslav on 05/05/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

public extension UIDevice {
    /// Returns true if the current device is simulator
    public var isSimulator: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
}
