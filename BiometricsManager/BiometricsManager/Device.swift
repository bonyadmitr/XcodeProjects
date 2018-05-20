//
//  Device.swift
//  BiometricsManager
//
//  Created by Bondar Yaroslav on 5/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class Device {
    /// https://stackoverflow.com/questions/46192280/detect-if-the-device-is-iphone-x
    static var isIphoneX: Bool {
        return (UIDevice.current.userInterfaceIdiom == .phone) && (UIScreen.main.nativeBounds.height == 2436)
    }
}
