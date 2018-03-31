//
//  AssociationManager.swift
//  PullToRefreshTest
//
//  Created by Bondar Yaroslav on 15/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation
import ObjectiveC

/// http://stackoverflow.com/questions/25426780/how-to-have-stored-properties-in-swift-the-same-way-i-had-on-objective-c
///
/// Example:
/// ```
/// extension SomeType {
///    private static let association = ObjectAssociation<NSObject>()
///
///    var simulatedProperty: NSObject? {
///        get { return SomeType.association[self] }
///        set { SomeType.association[self] = newValue }
///    }
///}
/// ```
public final class AssociationManager<T> {
    
    private let policy: objc_AssociationPolicy
    
    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }
    
    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: Any) -> T? {
        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}
