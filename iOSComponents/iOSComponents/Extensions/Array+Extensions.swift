//
//  Array+Extensions.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// example
//lazy var vc: ViewController = {
//    return self.childViewControllers.first(of: ViewController.self)!
//}()
extension Array {
    public func first<T>(of type: T.Type) -> T? {
        return first { $0 is T } as? T
    }
}
