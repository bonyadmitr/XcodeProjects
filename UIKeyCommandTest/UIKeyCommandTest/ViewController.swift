//
//  ViewController.swift
//  UIKeyCommandTest
//
//  Created by Yaroslav Bondar on 30/07/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textView = UITextView(frame: view.bounds)
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.backgroundColor = .lightGray
        textView.becomeFirstResponder()
        view.addSubview(textView)
        
        
        let button = UIButton(frame: .init(x: 100, y: 100, width: 100, height: 100))
        button.setTitle("show", for: .normal)
        button.addTarget(self, action: #selector(push), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc private func push() {
        let vc = ViewController()
        vc.view.backgroundColor = .darkGray
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override open var keyCommands: [UIKeyCommand]? {
        /// with only modifierFlags .shift will prevent selection in text enter views (UITextField, UITextView)
        return [UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [.shift, .command], action: #selector(push), discoverabilityTitle: "Back")]
    }
    
//    @objc private func backCommand() {
//        print("- backCommand")
//    }
}


extension UINavigationController {
    
    /*
     Adds keyboard shortcuts to navigate back in a navigation controller.
     - Shift + left arrow on the simulator
     */
    override open var keyCommands: [UIKeyCommand]? {
        guard viewControllers.count > 1 else { return [] }
        return [UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [.shift, .command], action: #selector(backCommand), discoverabilityTitle: "Back")]
    }
    
    @objc private func backCommand() {
        print("- backCommand")
        popViewController(animated: true)
    }
    
//    override open var canBecomeFirstResponder: Bool {
//        return true
//    }
}
