//
//  OCBackendError.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 22.06.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import Alamofire
import ObjectMapper


// MARK: - Translatable
protocol Translatable {
    func translated(locale l: NSLocale) -> String
}


// MARK: - OCBackendError
class OCBackendError: Mappable, ErrorType, Translatable {
    
    // MARK: - Properties
    var code: String
    var error: ErrorType?
    
    
    // MARK: - Life cycle
    init(code: String = "UNKNOWN_ERROR", error: ErrorType? = nil) {
        self.code = code
        self.error = error
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    // MARK: - Methods
    func mapping(map: Map) {
        code  <- map["error.code"]
        //TODO: Maybe this can help in future bugs
//        if let _ = map["error.code"].currentValue as? String {
//            code  <- map["error.code"]
//        } else {
//            code  <- map["error.code"]
//        }
    }
    
    func translated(locale l: NSLocale = NSLocale.currentLocale()) -> String {
        return code
    }
    
    static func composeError(error: ErrorType, data: NSData? = nil) -> ErrorType {
        if let data = data where data.length != 0 {
            let errorJSONString = NSString(data: data, encoding:NSUTF8StringEncoding)
            if let error = Mapper<OCBackendError>().map(errorJSONString!) {
                return error
            }
        }
        
        let error = error as NSError
        switch error.code {
        case -1009:
            return OCBackendError(code: "INTERNET_OFFLINE", error: error)
        default:
            return OCBackendError(error: error)
        }
    }
}


// MARK: - ValidationError
enum ValidationError: ErrorType, Translatable {
    case WrongValue(reason: String)
    case Invalid(field: String)
    case Empty(field: String)
    case EmptyCredentials
    case Offline
    
    func translated(locale l: NSLocale = NSLocale.currentLocale()) -> String {
        switch self {
        case .Invalid(field: let field):
            return "INVALID_" + field
        case .EmptyCredentials():
            return "HAS_NO_CREDENTIALS"
        case .Empty(field: let field):
            return "EMPTY_" + field
        default:
            return "VALIDATION_ERROR"
        }
    }
}