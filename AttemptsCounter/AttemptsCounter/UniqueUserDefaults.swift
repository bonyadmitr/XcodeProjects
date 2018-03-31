//
//  UniqueUserDefaults.swift
//  AttemptsCounter
//
//  Created by Bondar Yaroslav on 3/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

final class UserDefaultsForID: StorageForID {
    private let id: String
    
    init(id: String) {
        self.id = id
    }
    
    func set(_ object: Any, for key: String) {
        var dict = UserDefaults.standard.object(forKey: id) as? [String: Any] ?? [:]
        dict[key] = object
        UserDefaults.standard.set(dict, forKey: id)
    }
    
    func object(for key: String) -> Any? {
        let dict = UserDefaults.standard.object(forKey: id) as? [String: Any]
        return dict?[key]
    }
}
