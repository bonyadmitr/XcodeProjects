import Foundation
import Alamofire

extension DispatchQueue {
    static let background = DispatchQueue.global()
}

extension Session {
    
    static let withoutAuth: Session = {
        let configuration = URLSessionConfiguration.default
        //configuration.httpAdditionalHeaders = Session.defaultCustomHTTPHeaders
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
