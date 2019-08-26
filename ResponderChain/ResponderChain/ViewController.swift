//
//  ViewController.swift
//  ResponderChain
//
//  Created by Bondar Yaroslav on 8/25/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func loadView() {
        view = SomeView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.sizeToFit()
        button.center = view.center
        view.addSubview(button)
        
        print(view.responderChain())
        
        button.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
//        button.addTarget(self, action: #selector(actionButton(sender:event:)), for: .touchUpInside)
//        button.addTarget(self, action: Selector("actionButtonWithSender:event:"), for: .touchUpInside)
//        button.addTarget(self, action: NSSelectorFromString("actionButtonWithSender:event:"), for: .touchUpInside)
    }
    
    @objc func actionButton() {
        print("- Button", #line, #function, type(of: self))
    }
    
//    @objc func actionButton(sender: Any?, event: UIEvent?) {
//        print("- Button", #line, #function, type(of: self))
//    }
//
//    @objc static func actionButton(sender: Any?, event: UIEvent?) {
//        print("- Button", #line, #function, type(of: self))
//    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        print("-", #line, #function, type(of: self))
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        print("-", #line, #function, type(of: self))
        return super.target(forAction: action, withSender: sender)
    }
}

final class SomeView: UIView {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        print("-", #line, #function, type(of: self))
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        print("-", #line, #function, type(of: self))
        return super.target(forAction: action, withSender: sender)
    }
    
//    @objc func actionButton() {
//        print("- Button", #line, #function, type(of: self))
//    }
}

final class SomeWindow: UIWindow {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        print("-", #line, #function, type(of: self))
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        print("-", #line, #function, type(of: self))
        return super.target(forAction: action, withSender: sender)
    }
    
    @objc func actionButton() {
        print("- Button", #line, #function, type(of: self))
    }
}


extension UIResponder {
    func responderChain() -> String {
        guard let next = next else {
            return "\(type(of: self))"
        }
        return "\(type(of: self)) -> \(next.responderChain())"
        
//        guard let next = next else {
//            return String(describing: self)
//        }
//        return String(describing: self) + " -> " + next.responderChain()
    }
}
