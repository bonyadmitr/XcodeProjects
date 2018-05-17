//
//  UserDefaults+Init.swift
//  OptIn
//
//  Created by Bondar Yaroslav on 5/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension UserDefaults {
    static func forUniqueID(_ id: String) -> UserDefaults? {
        return UserDefaults(suiteName: id)
    }
}
