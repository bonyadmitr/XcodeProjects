//
//  Alamofire+Response.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 1/23/18.
//  Copyright © 2018 LifeTech. All rights reserved.
//

import Foundation
import Alamofire

extension Alamofire.DataRequest {
    
    func responseArray<T: DataMapArray>(_ handler: @escaping ResponseArrayHandler<T>) {
        responseData { response in
            switch response.result {
            case .success(let data):
                handler(ResponseParser.parseArray(data: data))
            case .failure(let error):
                let backendError = ResponseParser.getBackendError(data: response.data,
                                                                  response: response.response)
                handler(ResponseResult.failed(backendError ?? error))
            }
        }
    }
    
    func responseObject<T: DataMap>(_ handler: @escaping ResponseHandler<T>) {
        responseData { response in
            switch response.result {
            case .success(let data):
                handler(ResponseParser.parse(data: data))
            case .failure(let error):
                let backendError = ResponseParser.getBackendError(data: response.data,
                                                                  response: response.response)
                handler(ResponseResult.failed(backendError ?? error))
            }
        }
    }
    
    func responseVoid(_ handler: @escaping ResponseHandler<Void>) {
        responseString { response in
            switch response.result {
            case .success(_):
                handler(ResponseResult.success(()))
            case .failure(let error):
                let backendError = ResponseParser.getBackendError(data: response.data,
                                                                  response: response.response)
                handler(ResponseResult.failed(backendError ?? error))
            }
        }
    }
}
