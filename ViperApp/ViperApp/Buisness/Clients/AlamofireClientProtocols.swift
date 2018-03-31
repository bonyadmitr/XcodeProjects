//
//  AlamofireClientProtocols.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 29/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import PromiseKit
import Alamofire

protocol UrlsBase {
    static var all: URL { get }
    static func one(id: Int) -> URL
}

protocol ClientBase {
    associatedtype Entity: Codable
    associatedtype Paths: UrlsBase
}


protocol ClientGetAll: ClientBase {
    func all() -> Promise<[Entity]>
}
extension ClientGetAll {
    func all() -> Promise<[Entity]> {
        return request(Paths.all)
            .validate()
            .responseArray(or: BackendError.self)
    }
}

protocol ClientGetOne: ClientBase {
    func one(id: Int) -> Promise<Entity>
}
extension ClientGetOne {
    func one(id: Int) -> Promise<Entity> {
        return request(Paths.one(id: id))
            .validate()
            .responseObject(or: BackendError.self)
    }
}
