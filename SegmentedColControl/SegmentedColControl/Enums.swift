//
//  Enums.swift
//  SegmentedColControl
//
//  Created by Bondar Yaroslav on 28/03/2017.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import Foundation
import CoreGraphics

enum SelectiongAnimation {
    case none
    case basic
    case spring
}

enum CellHeight {
    case image
    case imageWith(CGFloat)
    case custom(CGFloat)
}

enum SelectingViewSize {
    case inset(dx: CGFloat, dy: CGFloat)
    case custom(CGSize)
}
