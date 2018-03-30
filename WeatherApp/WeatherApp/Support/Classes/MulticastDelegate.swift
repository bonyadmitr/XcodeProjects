//
//  MulticastDelegate.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 15/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

final class MulticastDelegate <T> {
    private var weakDelegates = [WeakWrapper]()
    
    func add(_ delegate: T) {
        weakDelegates.append(WeakWrapper(value: delegate as AnyObject))
    }
    
    func remove(_ delegate: T) {
        weakDelegates = weakDelegates.filter { $0.value !== delegate as AnyObject }
    }
    
    func invoke(invocation: (T) -> Void) {
        // Enumerating in reverse order prevents a race condition from happening when removing elements.
        for (index, delegate) in weakDelegates.enumerated().reversed() {
            if let delegate = delegate.value as? T {
                invocation(delegate)
            } else {
                weakDelegates.remove(at: index)
            }
        }
    }
}

func += <T: AnyObject> (left: MulticastDelegate<T>, right: T) {
    left.add(right)
}

func -= <T: AnyObject> (left: MulticastDelegate<T>, right: T) {
    left.remove(right)
}

private class WeakWrapper {
    weak var value: AnyObject?
    
    init(value: AnyObject) {
        self.value = value
    }
}
