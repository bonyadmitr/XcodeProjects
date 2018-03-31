//
//  Сustomizable.swift
//  Images
//
//  Created by Bondar Yaroslav on 30/01/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol Сustomizable: class {}

extension NSObject: Сustomizable {}

extension Сustomizable {
    func setup(_ closure: @escaping (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}
