//
//  Alamofire+PromisableMapping.swift
//  iGuru
//
//  Created by Yaroslav Bondar on 07.02.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import ObjectMapper
import Alamofire
import PromiseKit

extension Alamofire.DataRequest {
    struct MappingError: Error {
        let jsonString: String
        let targetType: Any.Type
    }
    
    struct MissingHeaderError: Error {
        let key: String
    }
    
    func responseVoid<E: Error & Mappable>(orError: E.Type) -> Promise<Void> {
        return Promise { fulfill, reject in
            response { (response) in
                guard let error = response.error else {
                    return fulfill()
                }
                reject(self.extractError(ofType: E.self, fromError: error, responseData: response.data))
            }.log()
        }
    }
    
    func responseObject<T: Mappable>() -> Promise<T> {
        return Promise { fulfill, reject in
            responseString { (response) in
                switch response.result {
                case .success(let value):
                    guard let object: T = Mapper().map(JSONString: value) else {
                        return reject(MappingError(jsonString: value, targetType: T.self))
                    }
                    fulfill(object)
                case .failure(let error):
                    reject(error)
                }
            }.log()
        }
    }
    
    func responseObject<T: Mappable, E: Error & Mappable>(orError: E.Type) -> Promise<T> {
        return Promise { fulfill, reject in
            responseString { (response) in
                switch response.result {
                case .success(let value):
                    guard let object: T = Mapper().map(JSONString: value) else {
                        return reject(MappingError(jsonString: value, targetType: T.self))
                    }
                    fulfill(object)
                case .failure(let error):
                    reject(self.extractError(ofType: E.self, fromError: error, responseData: response.data))
                }
            }.log()
        }
    }
    
    func responseArray<T: ImmutableMappable, E: Error & Mappable>(orError: E.Type) -> Promise<[T]> {
        return Promise { fulfill, reject in
            responseString { (response) in
                switch response.result {
                case .success(let value):
                    guard let objects: [T] = try? Mapper().mapArray(JSONString: value) else {
                        return reject(MappingError(jsonString: value, targetType: [T].self))
                    }
                    fulfill(objects)
                case .failure(let error):
                    reject(self.extractError(ofType: E.self, fromError: error, responseData: response.data))
                }
            }.log()
        }
    }
    
    func responseArray<T: Mappable, E: Error & Mappable>(orError: E.Type) -> Promise<[T]> {
        return Promise { fulfill, reject in
            responseString { (response) in
                switch response.result {
                case .success(let value):
                    guard let objects: [T] = Mapper().mapArray(JSONString: value) else {
                        return reject(MappingError(jsonString: value, targetType: [T].self))
                    }
                    fulfill(objects)
                case .failure(let error):
                    reject(self.extractError(ofType: E.self, fromError: error, responseData: response.data))
                }
            }.log()
        }
    }
    
    func responseArray<T: Mappable, E: Error & Mappable>(orError: E.Type) -> Promise<([T], Int)> {
        return Promise { fulfill, reject in
            responseString { (response) in
                switch response.result {
                case .success(let value):
                    guard let objects: [T] = Mapper().mapArray(JSONString: value) else {
                        return reject(MappingError(jsonString: value, targetType: [T].self))
                    }
                    let totalCountHeader = "X-Total-Count"
                    guard let totalString = response.response?.allHeaderFields[totalCountHeader] as? String, let total = Int(totalString) else {
                        return reject(MissingHeaderError(key: totalCountHeader))
                    }
                    fulfill(objects, total)
                case .failure(let error):
                    reject(self.extractError(ofType: E.self, fromError: error, responseData: response.data))
                }
            }
        }
    }
    
    private func extractError<E: Error & Mappable>(ofType: E.Type, fromError error: Error, responseData data: Data?) -> Error {
        guard let data = data, let jsonString = String(data: data, encoding: .utf8) else {
            return error
        }
        if let err = error as? URLError {
            return err
        }
        guard let errorObject: E = Mapper().map(JSONString: jsonString) else {
            return MappingError(jsonString: jsonString, targetType: E.self)
        }
        return errorObject
    }
}
