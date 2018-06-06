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
public protocol URLConvertible {
    func asURL() throws -> URL
}

extension String: URLConvertible {
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw URLSessionWrapperErrors.invalidURL(url: self)
        }
        return url
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
