//
//  MapToJSON.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// for custom classes and structs
/// TEST for subclasses
/// TEST for custom classes in properties
protocol MapToJSON {
    var json: [String: Any] { get }
}
extension MapToJSON {
    var json: [String: Any] {
        let bookMirror = Mirror(reflecting: self)
        var dict: [String: Any] = [:]
        for (name, value) in bookMirror.children {
            guard let name = name else { continue }
            dict[name] = unwrapOptional(any: value)
        }
        return dict
    }
    
    /// https://stackoverflow.com/a/43323245/5893286
    private func unwrapOptional(any: Any) -> Any {
        let mirror = Mirror(reflecting: any)
        guard mirror.displayStyle == .optional, let first = mirror.children.first else {
            return any
        }
        return first.value
//        let mi = Mirror(reflecting: any)
//        if mi.displayStyle != .optional {
//            return any
//        }
//        if mi.children.count == 0 {
//            return NSNull()
//        }
//        let (_, some) = mi.children.first!
//        return some
    }
}
