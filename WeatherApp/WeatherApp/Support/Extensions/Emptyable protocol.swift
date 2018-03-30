//
//  Emptyable.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 19/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol Emptyable {
    var isEmpty: Bool { get }
    var notEmpty: Bool { get }
}
extension Emptyable {
    var notEmpty: Bool {
        return !isEmpty
    }
}

extension Array: Emptyable {}
extension String: Emptyable {}
