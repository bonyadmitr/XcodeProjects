//
//  Realm+Array.swift
//  Networking
//
//  Created by Bondar Yaroslav on 10.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import RealmSwift
import PromiseKit

extension Results {
    var array: [T] {
        return self.map{$0}
    }
}

extension RealmSwift.List {
    var array: [T] {
        return self.map{$0}
    }
}

extension Realm {
    static var main: Promise<Realm> {
        return Promise(resolvers: { (fulfill, reject) in
            do {
                let realm = try Realm()
                fulfill(realm)
            } catch let error as NSError {
                reject(error)
            }
        })
    }
}
