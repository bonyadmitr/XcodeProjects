//
//  NSObject+AccessLabel.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 24/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension NSObject {
    @IBInspectable var accessLabel: String? {
        get { return accessibilityLabel }
        set { accessibilityLabel = newValue }
    }
}
