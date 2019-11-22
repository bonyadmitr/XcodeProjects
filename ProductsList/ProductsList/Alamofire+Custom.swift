import Foundation
import Alamofire

extension DispatchQueue {
    static let background = DispatchQueue.global()
}

extension Session {
    
    static let withoutAuth: Session = {
        /// privacy https://developer.apple.com/documentation/foundation/urlsessionconfiguration/1410529-ephemeral
        let configuration = URLSessionConfiguration.ephemeral
        
        /// disable caching https://stackoverflow.com/a/42722401/5893286
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        
        return Session(configuration: configuration)
    }()
}

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
