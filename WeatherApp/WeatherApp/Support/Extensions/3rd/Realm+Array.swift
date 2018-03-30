//
//  Realm+Array.swift
//  iGuru
//
//  Created by Yaroslav Bondar on 09.02.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import RealmSwift

extension Results {
    var array: [T] {
        return Array(self)// self.map{$0}
    }
}

extension RealmSwift.List {
    var array: [T] {
        return Array(self)
    }
}
