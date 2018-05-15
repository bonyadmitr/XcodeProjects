//
//  Array+Safe.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 9/18/17.
//  Copyright © 2017 LifeTech. All rights reserved.
//

import Foundation

/// https://stackoverflow.com/a/30593673
extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
