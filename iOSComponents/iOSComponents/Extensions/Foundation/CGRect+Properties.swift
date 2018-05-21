//
//  CGRect+Properties.swift
//  AccountManager
//
//  Created by Bondar Yaroslav on 02/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import CoreGraphics

extension CGRect {
    var isSquare: Bool {
        return width == height
    }
}
