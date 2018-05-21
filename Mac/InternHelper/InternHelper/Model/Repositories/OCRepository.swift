//
//  OCRepository.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 21.06.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import PromiseKit

class OCRepository <T: OCEntity> {
    
    // MARK: - Properties
    var baseUrl: URLStringConvertible
//        {
//        get {
//            print("baseUrl get \(self.baseUrl)")
//            return self.baseUrl
//        }
//        set {
//            
//            baseUrl = newValue
//            print("baseUrl newValue\(self.baseUrl)")
//        }
//    }
    
    var token : OCToken? {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            if let tokenId = defaults.stringForKey("token") {
                return OCToken(id: tokenId)
            }
            return nil
        }
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(newValue?.id, forKey: "token")
        }
    }

    
    // MARK: - Life cycle
    init(baseUrl: URLStringConvertible) {
        self.baseUrl = baseUrl
    }
    
    func generatePaginator(delegate: OCPaginatorDelegate) -> OCPaginator<T> {
        return OCPaginator(repository: self, delegate: delegate)
    }
    
    
    // MARK: Custom request methods
    func repoRequest(method: Alamofire.Method, _ URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request
    {
        var finalHeaders = headers ?? [:]
        if let token = self.token {
            finalHeaders["Authorization"] = token.id
            print(token.id)
        }
        
        return request(method, URLString, parameters: parameters, encoding: encoding, headers: finalHeaders)
    }
    
    func repoUpload(method: Alamofire.Method,
                  _ URLString: URLStringConvertible,
                    headers: [String: String]? = nil,
                    multipartFormData: MultipartFormData -> Void,
                    encodingMemoryThreshold: UInt64 = Manager.MultipartFormDataEncodingMemoryThreshold,
                    encodingCompletion: (Manager.MultipartFormDataEncodingResult -> Void)?) {
        
        var finalHeaders = headers ?? [:]
        if let token = self.token {
            finalHeaders["Authorization"] = token.id
            print(token.id)
        }
        
        return  upload(method, URLString, headers: finalHeaders, multipartFormData: multipartFormData, encodingMemoryThreshold: encodingMemoryThreshold, encodingCompletion: encodingCompletion)
    }
    
    
    // MARK: - Methods
    func findAll(filter: [String: AnyObject]? = nil) -> Promise<[T]> {
        return Promise.init(resolvers: { (fulfill, reject) in
            let params: [String: AnyObject]? = (filter != nil) ? ["filter": filter!] : nil
            repoRequest(.GET, baseUrl, parameters: params).validate().responseArray { (response: Response<[T], NSError>) in
                switch response.result {
                case .Success(let array):
                    fulfill(array)
                case .Failure(let error):
                    reject(OCBackendError.composeError(error, data: response.data))
                }
            }
        })
    }
    
    func upsert(object: T) -> Promise<T> {
        return Promise(resolvers: { (fulfill, reject) in
            repoRequest(.PUT, baseUrl, parameters: object.toJSON()).validate().responseObject { (response: Response<T, NSError>) in
                switch response.result {
                case .Success(let array):
                    fulfill(array)
                case .Failure(let error):
                    reject(OCBackendError.composeError(error, data: response.data))
                }
            }
        })
    }
    
    func create(object: T) -> Promise<T> {
        return Promise(resolvers: { (fulfill, reject) in
            repoRequest(.POST, baseUrl, parameters: object.toJSON()).validate().responseObject { (response: Response<T, NSError>) in
                switch response.result {
                case .Success(let object):
                    fulfill(object)
                case .Failure(let error):
                    reject(OCBackendError.composeError(error, data: response.data))
                }
            }
        })
    }

    func count() -> Promise<Int> {
        return Promise(resolvers: { (fulfill, reject) in
            repoRequest(.GET, baseUrl.appendingPathComponent("count")).validate().responseJSON(completionHandler: { (response) in
                switch response.result {
                case .Success(let data):
                    guard let dict = data as? [String: Int], count = dict["count"] else {
                        return reject(OCBackendError())
                    }
                    fulfill(count)
                case .Failure(let error):
                    reject(OCBackendError.composeError(error, data: response.data))
                }
            })
        })
    }
    
    
    // MARK: - Methods solo
    func getBy(id id: Int, filter: [String: AnyObject]? = nil) -> Promise<T> {
        return Promise.init(resolvers: { (fulfill, reject) in
            let params: [String: AnyObject]? = (filter != nil) ? ["filter": filter!] : nil
            repoRequest(.GET, baseUrl.appendingPathComponent(String(id)), parameters: params).validate().responseObject { (response: Response<T, NSError>) in
                switch response.result {
                case .Success(let array):
                    fulfill(array)
                case .Failure(let error):
                    reject(OCBackendError.composeError(error, data: response.data))
                }
            }
        })
    }
    
    func existsBy(id id: Int) -> Promise<Bool> {
        return Promise.init(resolvers: { (fulfill, reject) in
            repoRequest(.HEAD, baseUrl.appendingPathComponent(String(id))).validate().responseData(completionHandler: { (response) in
                
                if let response = response.response {
                    if response.statusCode == 200 || response.statusCode == 404 {
                        return fulfill(response.statusCode == 200)
                    }
                }
                
                switch response.result {
                case .Success(_):
                    fulfill(true)
                case .Failure(let error):
                    reject(OCBackendError.composeError(error, data: response.data))
                }
            })
        })
    }
    
    func update(object: T) -> Promise<T> {
        return Promise(resolvers: { (fulfill, reject) in
            
            guard let id = object.id else {
                return reject(OCBackendError(code:"OBJECT_HAS_NO_ID"))
            }
            
            repoRequest(.PUT, baseUrl.appendingPathComponent(String(id)), parameters: object.toJSON()).validate().responseObject { (response: Response<T, NSError>) in
                switch response.result {
                case .Success(let object):
                    fulfill(object)
                case .Failure(let error):
                    reject(OCBackendError.composeError(error, data: response.data))
                }
            }
        })
    }
    
    func delete(object: T) -> Promise<Void> {
        return Promise.init(resolvers: { (fulfill, reject) in
            
            guard let id = object.id else {
                return reject(OCBackendError(code:"OBJECT_HAS_NO_ID"))
            }
            
            repoRequest(.DELETE, baseUrl.appendingPathComponent(String(id))).validate().responseJSON(completionHandler: { (response) in
                switch response.result {
                case .Success(_):
                    fulfill()
                case .Failure(let error):
                    reject(OCBackendError.composeError(error, data: response.data))
                }
            })
        })
    }
}


// MARK: - OCEntity
protocol OCEntity: Mappable {
    var id : String? {get set}
}


// MARK: - extension URLStringConvertible
extension URLStringConvertible {
    func appendingPathComponent(string: String) -> URLStringConvertible {
        return NSURL(string: self.URLString)!.URLByAppendingPathComponent(string)
    }
}