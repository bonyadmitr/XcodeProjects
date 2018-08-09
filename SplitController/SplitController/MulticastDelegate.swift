//
//  MulticastDelegate.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol Multicaster {
    associatedtype MulticastType
    var delegates: MulticastDelegate<MulticastType> { get }
}
extension Multicaster {
    func register(_ delegate: MulticastType) {
        delegates.add(delegate)
    }
    func unregister(_ delegate: MulticastType) {
        delegates.remove(delegate)
    }
}

/// https://github.com/jonasman/MulticastDelegate/blob/master/Sources/MulticastDelegate.swift
/// can be Added check for same object in "add(_ delegate"
/// and need to remove filter in "remove(_ delegate"
final class MulticastDelegate<T> {
    private var weakDelegates = [WeakWrapper]()
    
    func add(_ delegate: T) {
        weakDelegates.append(WeakWrapper(value: delegate as AnyObject))
    }
    
    /// not nessary for dealocated objects,
    /// they will be removed automaticaly on invoke
    func remove(_ delegate: T) {
        weakDelegates = weakDelegates.filter { $0.value !== delegate as AnyObject }
    }
    
    func invoke(_ invocation: (T) -> Void) {
        /// Enumerating in reverse order prevents a race condition from happening when removing elements.
        for (index, delegate) in weakDelegates.enumerated().reversed() {
            if let delegate = delegate.value as? T {
                invocation(delegate)
            } else {
                weakDelegates.remove(at: index)
            }
        }
    }
}

private final class WeakWrapper {
    weak var value: AnyObject?
    
    init(value: AnyObject) {
        self.value = value
    }
}
