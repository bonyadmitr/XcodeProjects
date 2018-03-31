//
//  RealmProtocols.swift
//  Networking
//
//  Created by Bondar Yaroslav on 10.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import RealmSwift
import PromiseKit

protocol RealmDefault {
    static func getAllFromRealm() -> Promise<[Self]>
    static func saveInRealm(_ objects: [Self]) -> Promise<[Self]>
}

extension RealmDefault where Self: Object {
    
    static func getAllFromRealm() -> Promise<[Self]> {
        return Promise(resolvers: { (fulfill, reject) in
            firstly {
                Realm.main
            }.then { realm -> Void in
                let objects = realm.objects(Self.self)
                fulfill(objects.array)
            }.catch { error in
                reject(error)
            }
        })
    }
    
    static func saveInRealm(_ objects: [Self]) -> Promise<[Self]> {
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
}

extension RealmDefault where Self: RestGetArray {
    static func getWithCache(onSuccess: @escaping ([Self])->(), onError: ((Error)->())? ) {
        firstly {
            Self.getAllFromRealm()
        }.then { objects -> Promise<[Self]> in
            print("realm")
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            onSuccess(objects)
            return Self.getAll()
        }.then { objects -> Promise<[Self]> in
            print("web")
            return Self.saveInRealm(objects)
        }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }.then { objects -> Promise<[Self]> in
            print("saved")
            return Self.getAllFromRealm()
        }.then { objects -> Void in
            print("realm")
            onSuccess(objects)
        }.catch { error in
            print(error.localizedDescription)
            if let onError = onError {
                onError(error)
            }
        }
    }
}
