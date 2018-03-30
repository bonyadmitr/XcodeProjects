//
//  AlamofireLogger.swift
//  Ticketing
//
//  Created by Daniel Clelland on 10/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import Alamofire

///https://github.com/dclelland/AlamofireLogger

// MARK: Logging

/// The logging level. `.simple` prints only a brief request/response description; `.verbose` prints the request/response body as well.
public enum LogLevel {
    case none
    /// Prints the request and response at their respective `.simple` levels.
    case simple
    /// Prints the request and response at their respective `.verbose` levels.
    case verbose
    
    case debug
}

extension DataRequest {
    public static var logger: Logger {
        return Logger.shared
    }
}
public extension DataRequest {
    func debugLog() -> Self {
        if !DataRequest.logger.logResponse {
            return self
        }
        return responseJSON { response in
            self.logDivider()
            debugPrint(response)
        }
    }
}
public extension DataRequest {
    
    /// Log the request and response at the specified `level`.
    @discardableResult
    public func log(_ level: LogLevel = DataRequest.logger.logLevel) -> Self {
        switch level {
        case .none:
            return self
        case .simple:
            return logRequest(.simple).logResponse(.simple)
        case .verbose:
            return logRequest(.verbose).logResponse(.verbose)
        case .debug:
            return debugLog()
        }
    }

}

// MARK: - Request logging

public extension DataRequest {
    
    /// Log the request at the specified `level`.
    @discardableResult
    public func logRequest(_ level: LogLevel = .simple) -> Self {
        
        if !DataRequest.logger.logRequests {
            return self
        }
        
        guard let method = request?.httpMethod, let path = request?.url?.absoluteString else {
            return self
        }
        
        logDivider()
        
        if case .verbose = level, let data = request?.httpBody, let body = String(data: data, encoding: .utf8) {
            print("\(method) \(path): \"\(body)\"")
        } else {
            print("\(method) \(path)")
        }
        
        return self
    }
    
}

// MARK: - Response logging

public extension DataRequest {
    
    /// Log the response at the specified `level`.
    @discardableResult
    public func logResponse(_ level: LogLevel = .simple) -> Self {
        return response { response in
            
            if !DataRequest.logger.logResponse {
                return
            }

            guard let code = response.response?.statusCode, let path = response.request?.url?.absoluteString else {
                return
            }
            
            self.logDivider()
            
            if case .verbose = level, let data = response.data, let body = String(data: data, encoding: .utf8) {
                print("\(code) \(path): \"\(body)\"")
            } else {
                print("\(code) \(path)")
            }
        }
    }
}
private extension DataRequest {
    func logDivider() {
        print("---------------------")
    }
}
