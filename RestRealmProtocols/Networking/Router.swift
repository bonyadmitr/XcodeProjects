//
//  Router.swift
//  Networking
//
//  Created by Bondar Yaroslav on 12.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import PromiseKit

protocol RouterAll: RouterGet, RouterGetArray { }


protocol Router {
    associatedtype Model
    var baseUrl: String { get }
    var sessionManager: Alamofire.SessionManager { get }
    var adapter: AuthorizationAdapter { get }
}
extension Router {
    var sessionManager: Alamofire.SessionManager {
        let sm = Alamofire.SessionManager.default
        sm.adapter = adapter
        return sm
    }
    var adapter: AuthorizationAdapter {
        return AuthorizationAdapter.shared
    }
}


protocol RouterGet: Router {
    func get() -> Promise<Model>
}
extension RouterGet where Model: Mappable {
    func get() -> Promise<Model> {
        return Promise(resolvers: { (fulfill, reject) in
            sessionManager.request(baseUrl).validate().responseObject() { (response: DataResponse<Model>) in
                switch response.result {
                case .success(let object):
                    fulfill(object)
                case .failure(let error):
                    reject(error)
                }
            }
        })
    }
}


protocol RouterGetArray: Router {
    func getAll() -> Promise<[Model]>
}
extension RouterGetArray where Model: Mappable {
    func getAll() -> Promise<[Model]> {
        return Promise(resolvers: { (fulfill, reject) in
            sessionManager.request(baseUrl).validate().responseArray() { (response: DataResponse<[Model]>) in
                switch response.result {
                case .success(let object):
                    fulfill(object)
                case .failure(let error):
                    reject(error)
                }
            }
        })
    }
}
