//
//  Alamofire+Request.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 1/23/18.
//  Copyright © 2018 LifeTech. All rights reserved.
//

import Foundation
import Alamofire


extension SessionManager {
    func cancellAllRequests() {
        session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
}

/// to send string as request parameter
/// https://stackoverflow.com/a/28552198
/// Example: request(url, method: .post, encoding: text)
extension String: ParameterEncoding {

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        request.fillContentType()
        return request
    }
}

/// to send array as request parameter
/// https://stackoverflow.com/a/39959559
extension Array: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = try JSONSerialization.data(withJSONObject: self, options: [])
        request.fillContentType()
        return request
    }
}

/// need to test for some more requests
/// maybe need set headers only in service
extension URLRequest {
    fileprivate mutating func fillContentType() {
        let header = "Content-Type"
        if value(forHTTPHeaderField: header) == nil {
            setValue("application/json", forHTTPHeaderField: header)
        }
    }
}
