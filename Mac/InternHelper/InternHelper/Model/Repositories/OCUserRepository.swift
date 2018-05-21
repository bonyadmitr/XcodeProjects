//
//  OCUserRepository.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 22.06.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import PromiseKit
import Alamofire
import ObjectMapper
import Cocoa


// MARK: OCUserRepository
class OCUserRepository: OCRepository<OCUser> {
    
    // MARK: - private class RegistrationResponse
//    private class RegistrationResponse: Mappable {
//        
//        var user : OCUser?
//        var token : OCToken?
//        
//        required init?(_ map: Map) {}
//        
//        func mapping(map: Map) {
//            user <- map["user"]
//            token <- map["token"]
//        }
//    }
    
    
    // MARK: - Life cycle
    override init(baseUrl: URLStringConvertible) {
        super.init(baseUrl: baseUrl)
    }
    
    
    // MARK: - Methods
    func login(credetials: OCUserCredentials) -> Promise<OCToken> {
        return Promise(resolvers: { (fulfill, reject) in
            repoRequest(.POST, baseUrl.appendingPathComponent("login"), parameters: credetials.toJSON()).validate().responseObject(completionHandler: { (response: Response<OCToken, NSError>) in
                switch response.result {
                case .Success(let token):
                    fulfill(token)
                case .Failure(let error):
                    reject(OCBackendError.composeError(error, data: response.data))
                }
            })
        })
    }
    
    override func create(object: OCUser) -> Promise<OCUser> {
        return Promise(resolvers: { (fulfill, reject) in
            repoRequest(.POST, baseUrl, parameters: object.toJSON()).validate().responseObject { (response: Response<OCUser, NSError>) in
                switch response.result {
                case .Success(let object):
//                    guard let user = object as ocUser else {
//                        return reject(OCBackendError(code:"OBJECT_HAS_NO_USER"))
//                    }
                    fulfill(object)
                case .Failure(let error):
                    reject(OCBackendError.composeError(error, data: response.data))
                }
            }
        })
    }
    
    func getMe(filter: [String: AnyObject]? = nil) -> Promise<OCUser> {
        return Promise(resolvers: { (fulfill, reject) in
            let params: [String: AnyObject]? = (filter != nil) ? ["filter": filter!] : nil
            repoRequest(.GET, baseUrl.appendingPathComponent("me"), parameters: params).validate().responseObject { (response: Response<OCUser, NSError>) in
                switch response.result {
                case .Success(let user):
                    fulfill(user)
                case .Failure(let error):
                    reject(OCBackendError.composeError(error, data: response.data))
                }
            }
        })
    }
    
    func reset(credentials: OCUserCredentials) -> Promise<Void> {
        return Promise(resolvers: { (fulfill, reject) in
            repoRequest(.POST, baseUrl.appendingPathComponent("reset"), parameters: credentials.toJSON()).validate().responseData(completionHandler: { (response) in
                switch response.result {
                case .Success(_):
                    fulfill()
                case .Failure(let error):
                    reject(OCBackendError.composeError(error, data: response.data))
                }
            })
        })
    }
    
    func logout() -> Promise<Void> {
        return Promise(resolvers: { (fulfill, reject) in
            repoRequest(.POST, baseUrl.appendingPathComponent("logout")).validate().responseData(completionHandler: { (response) in
                switch response.result {
                case .Success(_):
                    fulfill()
                case .Failure(let error):
                    reject(OCBackendError.composeError(error, data: response.data))
                }
            })
        })
    }
    
    
    
//    func getVerificationCode(credentials: OCUserCredentials)-> Promise<OCUserCredentials>{
//        return Promise(resolvers: { (fulfill, reject) in
//            repoRequest(.POST, baseUrl.appendingPathComponent("message"), parameters: credentials.toJSON()).validate().responseJSON { response in
//                switch response.result {
//                case .Success(let value as Dictionary<String, AnyObject>):
//                    credentials.code = value["id"] as? String
//                    fulfill(credentials)
//                case .Failure(let error):
//                    reject(OCBackendError.composeError(error, data: response.data))
//                default:
//                    break
//                }
//            }
//        })
//    }

}

