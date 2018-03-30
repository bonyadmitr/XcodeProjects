//
//  Promisable.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import PromiseKit

protocol Promisable {}

extension Promisable {
    var promise: Promise<Self> {
        return Promise(value: self)
    }
}
extension Array where Element: Promisable {
    var promise: Promise<[Element]> {
        return Promise(value: self)
    }
}
