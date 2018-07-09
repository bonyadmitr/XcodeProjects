//
//  URLConvertible.swift
//  URLSessionWrapper
//
//  Created by Bondar Yaroslav on 6/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// Types adopting the `URLConvertible` protocol can be used to construct URLs, which are then used to construct
/// URL requests.
public protocol URLConvertible: CustomStringConvertible {
    func asURL() throws -> URL
}

extension String: URLConvertible {
    public func asURL() throws -> URL {
        guard
            let encodedString = urlEncoded,
            let url = URL(string: encodedString)
            else {
                throw URLSessionWrapperErrors.invalidURL(url: self)
        }
        return url
    }
    
    public var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

}

extension URL: URLConvertible {
    public func asURL() throws -> URL {
        return self
    }
}

extension URLComponents: URLConvertible {
    public func asURL() throws -> URL {
        guard let url = url else { 
            throw URLSessionWrapperErrors.invalidURL(url: self)
        }
        return url
    }
}
