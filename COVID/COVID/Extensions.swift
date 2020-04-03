//
//  Extensions.swift
//  COVID
//
//  Created by Bondar Yaroslav on 4/3/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension URLSession {
    
    @discardableResult
    func codableDataTask<T: Codable>(with url: URL, completionHandler: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let object = try decoder.decode(T.self, from: data)
                    completionHandler(.success(object))
                } catch {
                    completionHandler(.failure(error))
                }
            } else {
                assertionFailure(response.debugDescription)
                completionHandler(.failure(CustomErrors.unknown))
            }

        }
        
        task.resume()
        return task
    }
}

//extension Data {
//    var stringValue: String {
//        return String(data: self, encoding: .utf8) ?? String(describing: self)
//    }
//}

//extension Collection where Indices.Iterator.Element == Index {
//
//    /// article https://medium.com/flawless-app-stories/say-goodbye-to-index-out-of-range-swift-eca7c4c7b6ca
//    subscript(safe index: Index) -> Iterator.Element? {
//        return (startIndex <= index && index < endIndex) ? self[index] : nil
//    }
//}

//extension JSONDecoder {
//
//    /// JSONDecoder keypath
//    /// another solution https://github.com/dgrzeszczak/KeyedCodable/
//    /// another solution https://gist.github.com/aunnnn/9a6b4608ae49fe1594dbcabd9e607834
//    /// another solution https://github.com/aunnnn/NestedDecodable
//    ///
//    /// code https://gist.github.com/sgr-ksmt/d3b79ed1504768f2058c5ea06dc93698
//    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
//        let toplevel = try JSONSerialization.jsonObject(with: data)
//        if let nestedJson = (toplevel as AnyObject).value(forKeyPath: keyPath) {
//            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
//            return try decode(type, from: nestedJsonData)
//        } else {
//            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Nested json not found for key path \"\(keyPath)\""))
//        }
//    }
//}
