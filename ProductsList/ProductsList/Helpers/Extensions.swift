//
//  Extensions.swift
//  ProductsList
//
//  Created by Bondar Yaroslav on 11/26/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Foundation

typealias ErrorCompletion = (Error?) -> Void

/// there is no CustomDebugStringConvertible bcz of error:
/// Extension of protocol 'Error' cannot have an inheritance clause
extension Error {
    var debugDescription: String {
        return String(describing: self)
    }
}

extension Data {
    var stringValue: String {
        return String(data: self, encoding: .utf8) ?? String(describing: self)
    }
}
