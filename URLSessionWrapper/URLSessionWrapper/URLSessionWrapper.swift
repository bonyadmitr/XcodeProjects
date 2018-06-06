//
//  URLSessionWrapper.swift
//  URLSessionWrapper
//
//  Created by Bondar Yaroslav on 6/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

typealias VoidResult = (Result<Void>) -> Void
typealias BoolResult = (Result<Bool>) -> Void
typealias DataResult = (Result<Data>) -> Void
typealias HandlerResult<T> = (Result<T>) -> Void
typealias ArrayHandlerResult<T> = (Result<[T]>) -> Void

enum Result<T> {
    case success(T)
    case failure(Error)
}

typealias HTTPheaders = [String: String]
typealias HTTPParameters = [String: String]
typealias ResponseValidator = (Data, HTTPURLResponse) -> Bool

final class URLSessionWrapper: NSObject {
    
//    static let shared 
    
//    lazy var downloadsSession: URLSession = {
//        let configuration = URLSessionConfiguration.default
//        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
//    }()

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case head = "HEAD"
        case delete = "DELETE"
        case put = "PUT"
        case patch = "PATCH"
    }
    
    static func request(_ method: HTTPMethod, path: String, headers: HTTPheaders?, parameters: HTTPParameters?, validator: ResponseValidator? = defaultValidator, completion: @escaping DataResult) {
        
        guard var components = URLComponents(string: path) else {
            let error = CustomErrors.systemDebug("invalid path for URL")
            completion(.failure(error))
            return 
        }
        
        var httpBody: Data?
        if let parameters = parameters {
            
            switch method {
            case .get, .head, .delete:
                components.queryItems = parameters.map { key, value in 
                    URLQueryItem(name: key, value: value) 
                }
            default:
                do {
                    httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                } catch {
                    completion(.failure(error))
                    return 
                }
            }
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        guard let url = components.url else {
            let error = CustomErrors.systemDebug("invalid path for URL")
            completion(.failure(error))
            return 
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 30
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = httpBody
        
        
//        let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
        
        request(urlRequest, validator: validator, completion: completion)
    }
    
    /// maybe add !data.isEmpty
    static let defaultValidator: ResponseValidator = { data, response in
        return (200 ..< 300) ~= response.statusCode
    }
    
    @discardableResult
    static func request(_ urlRequest: URLRequest, validator: ResponseValidator? = defaultValidator, completion: @escaping DataResult) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                
            } else if let data = data, let response = response as? HTTPURLResponse {
                
                if let validator = validator {
                    if validator(data, response) {
                        completion(.success(data))
                    } else {
                        // TODO: error
                        let error = CustomErrors.systemDebug("failed responseValidator \(validator), \(response)")
                        completion(.failure(error))
                    }
                } else {
                    completion(.success(data))
                }
                
            } else {
                let error = CustomErrors.systemDebug(response?.description ?? "response nil")
                completion(.failure(error))
            }
        }
        task.resume()
        return task
    }
    
}

extension URLSessionWrapper: URLSessionDelegate {
    
}
