//
//  ViewController.swift
//  ProductsList
//
//  Created by Bondar Yaroslav on 11/15/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    typealias Model = Product
    typealias Item = Model.Item
    private let service = Model.Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.all { result in
            switch result {
            case .success(let list):
                print(list)
            case .failure(let error):
                print(error.debugDescription)
            }
        }
    }

    
}

enum Product {
    
    struct Item: Decodable {
        let id: String
        let name: String
        let price: Int
        let imageUrl: String
        
        enum CodingKeys: String, CodingKey {
            case id = "product_id"
            case name
            case price
            case imageUrl = "image"
        }
    }
    
    final class Service {
        func all(handler: @escaping (Result<[Item], Error>) -> Void) {
            Session.withoutAuth
                .request(URLs.Products.all)
                .customValidate()
                .responseObject(keyPath: "products", completion: handler)
        }
    }
}

import Foundation

enum URLs {
    
    private static let basePath = "https://s3-eu-west-1.amazonaws.com/developer-application-test/"
    
    enum Products {
        private static let base = basePath + "cart/"
        
        static let all = base + "list"
        
        static func detail(id: Int) -> String {
            return base + "/\(id)/detail"
        }
    }
    
}

import Foundation

extension DispatchQueue {
    static let background = DispatchQueue.global()
}



import Alamofire

extension Session {
    
    static let withoutAuth: Session = {
        let configuration = URLSessionConfiguration.default
        //configuration.httpAdditionalHeaders = Session.defaultCustomHTTPHeaders
        return Session(configuration: configuration)
    }()
}

import Alamofire

/// here we can change global requests validation
extension DataRequest {
    @discardableResult
    public func customValidate() -> Self {
        return validate(statusCode: 200..<300)
    }
}

extension DownloadRequest {
    @discardableResult
    public func customValidate() -> Self {
        return validate(statusCode: 200..<300)
    }
}

extension JSONDecoder {
    
    /// JSONDecoder keypath
    /// another solution https://github.com/dgrzeszczak/KeyedCodable/
    /// another solution https://gist.github.com/aunnnn/9a6b4608ae49fe1594dbcabd9e607834
    /// another solution https://github.com/aunnnn/NestedDecodable
    ///
    /// code https://gist.github.com/sgr-ksmt/d3b79ed1504768f2058c5ea06dc93698
    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
        let toplevel = try JSONSerialization.jsonObject(with: data)
        if let nestedJson = (toplevel as AnyObject).value(forKeyPath: keyPath) {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
            return try decode(type, from: nestedJsonData)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Nested json not found for key path \"\(keyPath)\""))
        }
    }
}

import Foundation
import Alamofire

extension DataRequest {
    
    @discardableResult
    func responseObject<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) -> Self {
        return responseData(queue: .background) { responseData in
            switch responseData.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    
                    /// Custom Dates https://useyourloaf.com/blog/swift-codable-with-custom-dates/
                    /// custom iso8601 https://stackoverflow.com/a/46458771/5893286
                    decoder.dateDecodingStrategy = .millisecondsSince1970
                    
                    let object = try decoder.decode(T.self, from: data)
                    completion(.success(object))
                } catch {
                    //DecodingError
                    #if DEBUG
                    Self.printAssertFor(responseData: responseData, data: data, error: error)
                    #endif
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// can be named as responseArray
    @discardableResult
    func responseObject<T: Decodable>(completion: @escaping (Result<[T], Error>) -> Void) -> Self {
        return responseData(queue: .background) { responseData in
            switch responseData.result {
            case .success(let data):
                do {
                    let array = (try JSONDecoder().decode([FailableDecodable<T>].self, from: data)).compactMap ({ $0.base })
                    completion(.success(array))
                } catch {
                    //DecodingError
                    #if DEBUG
                    Self.printAssertFor(responseData: responseData, data: data, error: error)
                    #endif
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// can be named as responseArray
    @discardableResult
    func responseObject<T: Decodable>(keyPath: String, completion: @escaping (Result<[T], Error>) -> Void) -> Self {
        return responseData(queue: .background) { responseData in
            switch responseData.result {
            case .success(let data):
                do {
                    let array = (try JSONDecoder().decode([FailableDecodable<T>].self, from: data, keyPath: keyPath)).compactMap ({ $0.base })
                    completion(.success(array))
                } catch {
                    //DecodingError
                    #if DEBUG
                    Self.printAssertFor(responseData: responseData, data: data, error: error)
                    #endif
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func printAssertFor(responseData: AFDataResponse<Data>, data: Data, error: Error) {
        print("\n\n\n⚠️⚠️⚠️ failed request with:")
        print("- response:", responseData.response ?? "response nil")
        print("- data:", String(data: data, encoding: .utf8) ?? "failed data encoding")
        print("- error:", error.localizedDescription)
        assertionFailure(error.debugDescription)
    }
}

/// source https://stackoverflow.com/a/46369152/5893286
struct FailableDecodable<Base : Decodable> : Decodable {
    let base: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self.base = try container.decode(Base.self)
        } catch {
//            assertionFailure("- \(error.localizedDescription)\n\(error)")
            self.base = nil
        }
        
    }
}

/// there is no CustomDebugStringConvertible bcz of error:
/// Extension of protocol 'Error' cannot have an inheritance clause
extension Error {
    var debugDescription: String {
        return String(describing: self)
    }
}
