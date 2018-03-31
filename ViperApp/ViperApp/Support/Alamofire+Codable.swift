//
//  Alamofire+Codable.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 29/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Alamofire
import PromiseKit

/// MAYBE WILL BE NEED
///https://github.com/Otbivnoe/CodableAlamofire/blob/master/Sources/CodableAlamofire/DataRequest%2BDecodable.swift

/// MAYBE WILL BE NEED
//    let totalCountHeader = "X-Total-Count"
//    guard let totalString = response.response?.allHeaderFields[totalCountHeader] as? String, let total = Int(totalString) else {
//    return reject(MissingHeaderError(key: totalCountHeader))
//    }

final class MappingError {
    let jsonString: String
    init(data: Data) {
        jsonString = String(data: data, encoding: .utf8) ?? "Server error"
    }
}
extension MappingError: LocalizedError {
    var errorDescription: String? {
        return jsonString
    }
}

extension Alamofire.DataRequest {
    
    typealias CodableError = Codable & Error
    
    func responseArray<T: Codable, E: CodableError>(or error: E.Type) -> Promise<[T]> {
        return Promise { fulfill, reject in
            responseData { response in
                switch response.result {
                case .success(let data):
                    guard let objects = try? JSONDecoder().decode([T].self, from: data) else {
                        return reject(MappingError(data: data))
                    }
                    fulfill(objects)
                case .failure(let error):
                    reject(self.extractError(of: E.self, error: error, data: response.data))
                }
            }
        }
    }
    
    func responseObject<T: Codable, E: CodableError>(or error: E.Type) -> Promise<T> {
        return Promise { fulfill, reject in
            responseData { response in
                switch response.result {
                case .success(let data):
                    guard let objects = try? JSONDecoder().decode(T.self, from: data) else {
                        return reject(MappingError(data: data))
                    }
                    fulfill(objects)
                case .failure(let error):
                    reject(self.extractError(of: E.self, error: error, data: response.data))
                }
            }
        }
    }
    
    private func extractError<E: CodableError>(of type: E.Type, error: Error, data: Data?) -> Error {
        if let err = error as? URLError {
            return err
        }
        guard let data = data else {
            return error
        }
        guard let backendError = try? JSONDecoder().decode(E.self, from: data) else {
            return MappingError(data: data)
        }
        return backendError
    }
}
