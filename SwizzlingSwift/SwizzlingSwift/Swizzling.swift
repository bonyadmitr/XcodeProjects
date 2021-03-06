//
//  Swizzling.swift
//  SwizzlingSwift
//
//  Created by Bondar Yaroslav on 21/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// http://stackoverflow.com/questions/42824541/swift-3-1-deprecates-initialize-how-can-i-achieve-the-same-thing
extension UIApplication {
    
    private static let runOnce: Void = {
        SwizzlingManager.swizzlingAll()
    }()
    
    override open var next: UIResponder? {
        /// Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}

extension SwizzlingManager {
    static func swizzlingAll() {
        swizzlingSome()
        swizzlingViewDidLoad()
        swizzlingColor()
        swizzlingInit()
        swizzlingDealloc()
        swizzlingButton()
    }
}


extension SwizzlingManager {
    static func swizzlingViewDidLoad() {
        let original = #selector(UIViewController.viewDidLoad)
        let swizzled = #selector(UIViewController.sm_viewDidLoad)
        SwizzlingManager.swizzleInstanceMethod(UIViewController.self, from: original, to: swizzled)
    }
    static func swizzlingDealloc() {
        /// not available for NSObject due to crash
        SwizzlingManager.swizzleInstanceMethodString(UIViewController.self, from: "dealloc", to: "sm_dealloc")
    }
}
extension UIViewController {
    @objc func sm_viewDidLoad() {
        print("sm_viewDidLoad")
        /// if comment sm_viewDidLoad(), viewDidLoad will be called anyway
        sm_viewDidLoad()
    }
    @objc func sm_viewWillAppear() {
        print("sm_viewWillAppear")
        sm_viewWillAppear()
    }
}
extension UIViewController {
    @objc func sm_dealloc() {
        print("sm_dealloc:", classForCoder)
        /// we don't need to call sm_dealloc(). it will be called itself
    }
}


extension SwizzlingManager {
    static func swizzlingInit() {
        let original = #selector(UIView.init(coder:))
        let swizzled = #selector(UIView.init(sm_coder:))
        SwizzlingManager.swizzleInstanceMethod(UIView.self, from: original, to: swizzled)
    }
}
extension UIView {
    @objc convenience init?(sm_coder aDecoder: NSCoder) {
        self.init(sm_coder: aDecoder)
        print("init(sm_coder:)", classForCoder)
    }
}


extension SomeSiwzzable {
    @objc func sm_printSome() {
        print("sm_printSome")
        /// It will not be a recursive call anymore after the swizzling
        sm_printSome()
    }
}
extension SwizzlingManager {
    static func swizzlingSome() {
        let original = #selector(SomeSiwzzable.printSome)
        let swizzled = #selector(SomeSiwzzable.sm_printSome)
        SwizzlingManager.swizzleInstanceMethod(SomeSiwzzable.self, from: original, to: swizzled)
    }
}


extension UIColor {
    @objc class var sm_grey: UIColor {
        print("sm_grey")
        return .blue
    }
}
extension SwizzlingManager {
    static func swizzlingColor() {
        let original = #selector(getter: UIColor.lightGray)
        let swizzled = #selector(getter: UIColor.sm_grey)
        SwizzlingManager.swizzleClassMethod(UIColor.self, from: original, to: swizzled)
    }
}


extension UIButton {
    @objc func sm_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        print("sm_sendAction", action, target ?? "nil")
        sm_sendAction(action, to: target, for: event)
    }
}
extension SwizzlingManager {
    static func swizzlingButton() {
        let original = #selector(UIButton.sendAction(_:to:for:))
        let swizzled = #selector(UIButton.sm_sendAction(_:to:for:))
        SwizzlingManager.swizzleInstanceMethod(UIButton.self, from: original, to: swizzled)
    }
}

/// With Swift 3.1:
/// Method 'initialize()' defines Objective-C class method 'initialize',
/// which is not guaranteed to be invoked by Swift and will be disallowed in future versions.
/// So we can't use initialize().


//private let swizzling: (AnyClass, Selector, Selector) -> () = { forClass, originalSelector, swizzledSelector in
//    let originalMethod = class_getInstanceMethod(forClass, originalSelector)
//    let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
//    method_exchangeImplementations(originalMethod, swizzledMethod)
//}

//extension UIView {
//
//    open override class func initialize() {
//        // make sure this isn't a subclass
//        guard self === UIView.self else { return }
//        let originalSelector = #selector(layoutSubviews)
//        let swizzledSelector = #selector(swizzled_layoutSubviews)
//        swizzling(self, originalSelector, swizzledSelector)
//    }
//
//    func swizzled_layoutSubviews() {
//        swizzled_layoutSubviews()
//        print("swizzled_layoutSubviews")
//    }
//}
