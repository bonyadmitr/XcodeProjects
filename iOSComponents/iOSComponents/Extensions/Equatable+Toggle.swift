//
//  Equatable+Toggle.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension Equatable {
    mutating func toggle(with first: Self, and second: Self) {
        self = (self == first) ? first : second
    }
}
