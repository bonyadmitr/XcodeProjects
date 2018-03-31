//
//  DataBaseProvider.swift
//  Networking
//
//  Created by Bondar Yaroslav on 11.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import PromiseKit

protocol DataBaseProvider {
    associatedtype Model
    
    func getAll() -> Promise<[Model]>
    func add(_ objects: [Model]) -> Promise<[Model]>
    func add(_ object: Model) -> Promise<Model>
    func remove(_ object: Model) -> Promise<Model>
}
