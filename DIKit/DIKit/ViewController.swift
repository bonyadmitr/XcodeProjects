//
//  ViewController.swift
//  DIKit
//
//  Created by Bondar Yaroslav on 29/10/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol Storage: class {
    var value: Int {get set}
    func print()
}

class StorageImp: Storage {
    
    init() {
        Swift.print("StorageImp init")
    }
    
    var value = 0
    func print() {
        Swift.print(value)
    }
}


protocol Value {
    weak var storage: Storage? { get set }
    func print()
}
class ValueImp: Value {
    weak var storage: Storage?
    func print() {
        Swift.print(storage ?? "nil")
    }
}

class StorageImp2: Storage {
    
    init(value: Value) {
        Swift.print(value)
    }
    
    var value = 0
    func print() {
        Swift.print(value)
    }
}

let container = DIContainer()

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.register(ValueImp() as Value)
        container.register(StorageImp2(value: container.resolve()) as Storage)
        container.register(StorageImp() as Storage, key: "qqq")
        
        var value: Value = container.resolve()
        value.storage = container.resolve() as Storage
        value.print()
        
        let st: Storage = container.resolve()
        st.print()
        st.value = 1
        st.print()
        
        let st2: Storage = container.resolve()
        st2.print()
        st2.value = 2
        st2.print()
        
        let st3: Storage = container.resolve(key: "qqq")
        st3.print()
        st3.value = 3
        st3.print()
        
        let st4: Storage = container.resolve(scope: .instance, key: "qqq")
        st4.print()
        st4.value = 4
        st4.print()
    }
}


import Foundation

public typealias Injectable = Any

public enum DIScope {
    case singleton
    case instance
}

public final class DIContainer {
    
    private var injections: [String: Injectable] = [:]
    private var lazyInjections: [String: Injectable] = [:]

    public func register <T>(_ handler: @escaping @autoclosure () -> T, key: String = String(describing: T.self)) {
        if lazyInjections[key] == nil {
            lazyInjections[key] = handler
        }
    }
    
    public func resolve<T>(scope: DIScope = .singleton, key: String = String(describing: T.self)) -> T {
        
        switch scope {
        case .singleton:
            if let injection = injections[key], let instance = injection as? T {
                return instance
            } else if let lazyInjection = lazyInjections[key], let lazyInit = lazyInjection as? (() -> T) {
                let instance = lazyInit()
                injections[key] = instance
                return instance
            }
            
        case .instance:
            if let lazyInjection = lazyInjections[key], let lazyInit = lazyInjection as? (() -> T) {
                return lazyInit()
            }
        }

        fatalError("not registered instance of \"\(T.self)\" for key: \"\(key)\"\n")
    }
}
