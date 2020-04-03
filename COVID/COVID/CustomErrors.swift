import Foundation

enum CustomErrors: LocalizedError, DebugDescriptable {
    case decode(Error)
    case parse(Data)
    case server
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .decode(let error):
            #if DEBUG
            return error.debugDescription
            #else
            return "Server error 01"
            #endif
            
        case .parse(let data):
            #if DEBUG
            let response = String(data: data, encoding: .utf8) ?? ""
            return "- Parse error data:\n\(response)"
            #else
            // TODO: localize error to user
            return "server_error"
            #endif
            
        case .server:
            return "Server error 02"
            
        case .unknown:
            return "Internal error"
        }
    }
    
}

protocol DebugDescriptable {
    var debugDescription: String { get }
}
extension DebugDescriptable where Self: Error {
    var debugDescription: String {
        return localizedDescription
    }
}

extension Error {
    var debugDescription: String {
        if let error = self as? DebugDescriptable {
            return error.debugDescription
        } else {
            return String(describing: self)
        }
    }
}

extension Error {
    
    //var isNetworkError: Bool {
    //    ///This way we fix our 11 error(segmentation fault 11), when we are trying to downcast self to URLError
    //    //        return self is URLError
    //    return (self as NSError).domain == NSURLErrorDomain
    //}
    //
    //var urlErrorCode: URLError.Code {
    //    ///This way we fix our 11 error(segmentation fault 11), when we are trying to downcast self to URLError
    //    //        guard let urlError = self as? URLError else {
    //    return URLError.Code(rawValue: (self as NSError).code)
    //}
    
    var description: String {
        //if isNetworkError {
        //    switch urlErrorCode {
        //    case .notConnectedToInternet, .networkConnectionLost:
        //        return "TextConstants.errorConnectedToNetwork"
        //    default:
        //        return "TextConstants.errorBadConnection"
        //    }
        //}
        
        
        #if DEBUG
        return debugDescription
        #else
        return localizedDescription
        #endif
    }
}
