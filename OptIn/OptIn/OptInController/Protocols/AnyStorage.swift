//
//  AnyStorage.swift
//  OptIn
//
//  Created by Bondar Yaroslav on 5/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol AnyStorage {
    func set(_ value: Any?, forKey key: String)
    func object(forKey key: String) -> Any?
}

extension UserDefaults: AnyStorage {}
