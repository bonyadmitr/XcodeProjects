//
//  ViewController.swift
//  UIKeyCommandTest
//
//  Created by Yaroslav Bondar on 30/07/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.frame = view.bounds
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.backgroundColor = .lightGray
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }

    
    override var keyCommands: [UIKeyCommand]? {
        /// with only modifierFlags .shift will prevent selection in text enter views (UITextField, UITextView)
        return [UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [.control, .command], action: #selector(push), discoverabilityTitle: "Back")]
    }
    
//    @objc private func backCommand() {
//        print("- backCommand")
//    }
}

/// https://www.avanderlee.com/swift/uikeycommand-keyboard-shortcuts/
extension UINavigationController {
    
    /*
     Adds keyboard shortcuts to navigate back in a navigation controller.
     - Shift + left arrow on the simulator
     */
    override open var keyCommands: [UIKeyCommand]? {
        guard viewControllers.count > 1 else { return [] }
        return [UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [.control, .command], action: #selector(backCommand), discoverabilityTitle: "Back")]
    }
    
    @objc private func backCommand() {
        print("- backCommand")
        popViewController(animated: true)
    }
}
