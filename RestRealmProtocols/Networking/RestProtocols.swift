//
//  RestProtocols.swift
//  OrderAppCustomerMy
//
//  Created by zdaecqze zdaecq on 11.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import PromiseKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

protocol Rest {
    static var url: String { get }
}



protocol RestGet: Rest {
    static func get() -> Promise<Self>
}
extension RestGet where Self: Mappable {
    static func get() -> Promise<Self> {
        return Promise(resolvers: { (fulfill, reject) in
            request(Self.url).validate().responseObject() { (response: DataResponse<Self>) in
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



protocol RestGetArray: Rest {
    static func getAll() -> Promise<[Self]>
}
extension RestGetArray where Self: Mappable {
    static func getAll() -> Promise<[Self]> {
        return Promise(resolvers: { (fulfill, reject) in
            request(Self.url).validate().responseArray() { (response: DataResponse<[Self]>) in
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
