//
//  SwizzlingManager.swift
//  SwizzlingSwift
//
//  Created by Bondar Yaroslav on 21/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation
import ObjectiveC

/// example
//extension SwizzlingManager {
//    static func swizzlingViewDidLoad() {
//        let original = #selector(UIViewController.viewDidLoad)
//        let swizzled = #selector(UIViewController.sm_viewDidLoad)
//        SwizzlingManager.swizzleInstanceMethod(UIViewController.self, from: original, to: swizzled)
//    }
//    static func swizzlingDealloc() {
//        /// not available for NSObject due to crash
//        SwizzlingManager.swizzleInstanceMethodString(UIViewController.self, from: "dealloc", to: "sm_dealloc")
//    }
//}
//extension UIApplication {
//    
//    private static let runOnce: Void = {
//        SwizzlingManager.swizzlingAll()
//    }()
//    
//    override open var next: UIResponder? {
//        /// Called before applicationDidFinishLaunching
//        UIApplication.runOnce
//        return super.next
//    }
//}

/// maybe need to swizzle with method_setImplementation
/// https://blog.newrelic.com/2014/04/16/right-way-to-swizzle/
final class SwizzlingManager {
    
    /// https://github.com/inamiy/Swizzle/blob/master/Swizzle/Swizzle.swift
    private static func swizzleMethod(_ class_: AnyClass, from origin: Selector, to override: Selector, isClassMethod: Bool) {
        
        let c: AnyClass = isClassMethod ? object_getClass(class_) : class_
        
        let method1: Method = class_getInstanceMethod(c, origin)
        let method2: Method = class_getInstanceMethod(c, override)
        
        if class_addMethod(c, origin, method_getImplementation(method2), method_getTypeEncoding(method2)) {
            class_replaceMethod(c, override, method_getImplementation(method1), method_getTypeEncoding(method1))
        } else {
            method_exchangeImplementations(method1, method2)
        }
    }
    
    /// Instance-method swizzling.
    static func swizzleInstanceMethod(_ class_: AnyClass, from sel1: Selector, to sel2: Selector) {
        swizzleMethod(class_, from: sel1, to: sel2, isClassMethod: false)
    }
    
    /// Instance-method swizzling for unsafe raw-string.
    /// - Note: This is useful for non-`#selector`able methods e.g. `dealloc`, private ObjC methods.
    static func swizzleInstanceMethodString(_ class_: AnyClass, from sel1: String, to sel2: String) {
        swizzleInstanceMethod(class_, from: Selector(sel1), to: Selector(sel2))
    }
    
    /// Class-method swizzling.
    static func swizzleClassMethod(_ class_: AnyClass, from sel1: Selector, to sel2: Selector) {
        swizzleMethod(class_, from: sel1, to: sel2, isClassMethod: true)
    }
    
    /// Class-method swizzling for unsafe raw-string.
    static func swizzleClassMethodString(_ class_: AnyClass, from sel1: String, to sel2: String) {
        swizzleClassMethod(class_, from: Selector(sel1), to: Selector(sel2))
    }
}
