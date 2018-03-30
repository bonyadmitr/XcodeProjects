//
//  Collection+Safe.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 26/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

// where Indices.Iterator.Element == Index
extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
