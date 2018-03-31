//
//  Optional+Extensions.swift
//  Optionals
//
//  Created by Bondar Yaroslav on 01/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

///https://appventure.me/2018/01/10/optional-extensions/

extension Optional {
    /// Returns true if the optional is empty
    var isNil: Bool {
        return self == nil
    }
    
    /// Returns true if the optional is not empty
    var isSome: Bool {
        return self != nil
    }
}

extension Optional {
    /// Return the value of the Optional or the `default` parameter
    /// - param: The value to return if the optional is empty
    func or(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }
    
    /// Returns the unwrapped value of the optional *or*
    /// the result of an expression `else`
    /// I.e. optional.or(else: print("Arrr"))
    func or(else: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }
    
    /// Returns the unwrapped value of the optional *or*
    /// the result of calling the closure `else`
    /// I.e. optional.or(else: {
    /// ... do a lot of stuff
    /// })
    func or(else: () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }
    
    /// Returns the unwrapped contents of the optional if it is not empty
    /// If it is empty, throws exception `throw`
    func or(throw exception: Error) throws -> Wrapped {
        guard let unwrapped = self else { throw exception }
        return unwrapped
    }
}

extension Optional where Wrapped == Error {
    /// Only perform `else` if the optional has a non-empty error value
    func or(_ else: (Error) -> Void) {
        guard let error = self else { return }
        `else`(error)
    }
}

extension Optional {
    /// Executes the closure `some` if and only if the optional has a value
    func on(some: @autoclosure () throws -> Void) rethrows {
        if self != nil { try some() }
    }
    
    func on(some: () throws -> Void) rethrows {
        if self != nil { try some() }
    }
    
    /// Executes the closure `none` if and only if the optional has no value
    func on(none: @autoclosure () throws -> Void) rethrows {
        if self == nil { try none() }
    }
    
    func on(none: () throws -> Void) rethrows {
        if self == nil { try none() }
    }
}
