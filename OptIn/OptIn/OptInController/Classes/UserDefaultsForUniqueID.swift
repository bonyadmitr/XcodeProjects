//
//  UserDefaultsForUniqueID.swift
//  OptIn
//
//  Created by Bondar Yaroslav on 5/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

final class UserDefaultsForUniqueID {
    private let id: String
    
    init(id: String) {
        self.id = id
    }
}
extension UserDefaultsForUniqueID: AnyStorage {
    func set(_ object: Any?, forKey key: String) {
        var dict = UserDefaults.standard.object(forKey: id) as? [String: Any] ?? [:]
        dict[key] = object
        UserDefaults.standard.set(dict, forKey: id)
        
    }
    
    func object(forKey key: String) -> Any? {
        let dict = UserDefaults.standard.object(forKey: id) as? [String: Any]
        return dict?[key]
    }
}
