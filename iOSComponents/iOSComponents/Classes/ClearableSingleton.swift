//
//  ClearableSingleton.swift
//  ClearableSingleton
//
//  Created by Bondar Yaroslav on 14/05/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation
import ObjectiveC

/// Only for classes. Not structs or enums.
protocol ClearableSingleton: class {
    init()
    static var shared: Self { get set }
    static func clearShared()
}

private var singletonSharedKey: UInt8 = 0

extension ClearableSingleton {
    private static var _shared: Self! {
        get { return objc_getAssociatedObject(self, &singletonSharedKey) as? Self }
        set { objc_setAssociatedObject(self, &singletonSharedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    static var shared: Self {
        get {
            if _shared == nil {
                _shared = Self()
                return _shared
            }
            return _shared
        }
        set {
            _shared = newValue
        }
    }
    static func clearShared() {
        _shared = nil
    }
}
