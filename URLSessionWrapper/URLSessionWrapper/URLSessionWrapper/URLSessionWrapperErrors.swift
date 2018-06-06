//
//  URLSessionWrapperErrors.swift
//  URLSessionWrapper
//
//  Created by Bondar Yaroslav on 6/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

enum URLSessionWrapperErrors {
    case invalidURL(url: URLConvertible)
}
extension URLSessionWrapperErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            #if DEBUG
            return "invalidURL: \(url.description)"
            #else
            return "System error"
            #endif
        }
    }
}
