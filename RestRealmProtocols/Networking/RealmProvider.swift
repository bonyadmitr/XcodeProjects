//
//  RealmProvider.swift
//  Networking
//
//  Created by Bondar Yaroslav on 11.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import RealmSwift
import PromiseKit

class RealmProvider<T: Object>: DataBaseProvider {
    typealias Model = T
    
    func getAll() -> Promise<[T]> {
        return Promise(resolvers: { (fulfill, reject) in
            firstly {
                Realm.main
            }.then { realm -> Void in
                let objects = realm.objects(T.self)
                fulfill(objects.array)
            }.catch { error in
                reject(error)
            }
        })
    }
    
    func add(_ objects: [T]) -> Promise<[T]> {
        return Promise(resolvers: { (fulfill, reject) in
            firstly {
                Realm.main
            }.then { realm -> Void in
                do {
                    try realm.write {
                        realm.add(objects, update: true)
                    }
                    fulfill(objects)
                } catch let error as NSError {
                    reject(error)
                }
            }.catch { error in
                reject(error)
            }
        })
    }
    
    func add(_ object: T) -> Promise<T> {
        return Promise(resolvers: { (fulfill, reject) in
            firstly {
                Realm.main
            }.then { realm -> Void in
                do {
                    try realm.write {
                        realm.add(object, update: true)
                    }
                    fulfill(object)
                } catch let error as NSError {
                    reject(error)
                }
            }.catch { error in
                reject(error)
            }
        })
    }
    
    func remove(_ object: T) -> Promise<T>  {
        return Promise(resolvers: { (fulfill, reject) in
            firstly {
                Realm.main
            }.then { realm -> Void in
                do {
                    try realm.write {
                        realm.delete(object)
                    }
                    fulfill(object)
                } catch let error as NSError {
                    reject(error)
                }
            }.catch { error in
                reject(error)
            }
        })
    }
}
