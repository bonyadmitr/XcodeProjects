//
//  Device.swift
//  Images
//
//  Created by Bondar Yaroslav on 07/05/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class Device {
    static var isIpad = (UIDevice.current.userInterfaceIdiom == .pad)
}
