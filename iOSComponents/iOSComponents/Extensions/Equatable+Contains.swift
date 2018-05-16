//
//  Equatable+Contains.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 11/9/17.
//  Copyright © 2017 LifeTech. All rights reserved.
//

import Foundation

extension Equatable {
    func isСontained(in array: [Self]) -> Bool {
        return array.contains(self)
    }
}
