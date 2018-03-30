//
//  Collection+Safe.swift
//  AvailableDatePicker
//
//  Created by Bondar Yaroslav on 02/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
