//
//  ViewController.swift
//  StatusBarTap
//
//  Created by Yaroslav Bondr on 03.03.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
        
        let scrollView = UIScrollView()
//        let scrollView = UITableView()
        scrollView.frame = view.frame
        scrollView.contentOffset.y = 1
        scrollView.contentSize.height = view.bounds.height + 1
        scrollView.delegate = self
        view.addSubview(scrollView)

    }

}

extension ViewController: UIScrollViewDelegate, UITableViewDelegate {
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        print("ViewController status bar tapped")
        return true
    }
}
final class SwizzlingManager {
    
    static func swizzleMethod(_ class_: AnyClass, from origin: String, to override: String, isClassMethod: Bool) {
        swizzleMethod(class_, from: Selector(origin), to: Selector(override), isClassMethod: isClassMethod)
    }
    
    /// https://github.com/inamiy/Swizzle/blob/master/Swizzle/Swizzle.swift
    static func swizzleMethod(_ class_: AnyClass, from origin: Selector, to override: Selector, isClassMethod: Bool) {
        
        let aClass: AnyClass = isClassMethod ? object_getClass(class_) ?? class_ : class_
        
        guard
            let method1 = class_getInstanceMethod(aClass, origin),
            let method2 = class_getInstanceMethod(aClass, override)
        else {
            assertionFailure("object_getClass nil: \(object_getClass(class_) == nil)")
            return
        }
        
        if class_addMethod(aClass, origin, method_getImplementation(method2), method_getTypeEncoding(method2)) {
            class_replaceMethod(aClass, override, method_getImplementation(method1), method_getTypeEncoding(method1))
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
