//
//  RealmStorageProtocols.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import PromiseKit
import RealmSwift

protocol RealmAll: RealmGetAll, RealmSaveOne, RealmSaveMany {}

protocol RealmBase {
    associatedtype Entity: Object
    var realm: Promise<Realm> { get }
}
extension RealmBase {
    var realm: Promise<Realm> {
        return firstly {
            Promise(value: try Realm())
        }
    }
}

protocol RealmGetAll: RealmBase {
    func getAll() -> Promise<[Entity]>
}
extension RealmGetAll {
    func getAll() -> Promise<[Entity]> {
        return firstly {
            realm
        }.then { realm -> Promise<[Entity]> in
            let array = Array(realm.objects(Entity.self))
            return Promise(value: array)
        }
    }
}

protocol RealmSaveOne: RealmBase {
    func save(_ object: Entity) -> Promise<Entity>
}
extension RealmSaveOne {
    func save(_ object: Entity) -> Promise<Entity> {
        return firstly {
            realm
        }.then { realm -> Promise<Entity> in
            try realm.write {
                realm.add(object, update: true)
            }
            return Promise(value: object)
        }
    }
}

protocol RealmSaveMany: RealmBase {
    func save(_ objects: [Entity]) -> Promise<[Entity]>
}
extension RealmSaveMany {
    func save(_ objects: [Entity]) -> Promise<[Entity]> {
        return firstly {
            realm
        }.then { realm -> Promise<[Entity]> in
            try realm.write {
                realm.delete(realm.objects(Entity.self))
                realm.add(objects)
            }
            return Promise(value: objects)
        }
    }
}
