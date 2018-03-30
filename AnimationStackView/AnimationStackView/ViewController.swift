//
//  ViewController.swift
//  AnimationStackView
//
//  Created by Yaroslav Bondar on 28.09.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var stack3: UIStackView!
    @IBOutlet weak var textView1: AutoTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(open(sender:)))
        mainStack.addGestureRecognizer(tapGesture)
        
        close()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView1.setContentOffset(CGPoint(), animated: false)
    }
    
    //gesture

    func open(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            self.toggle()
        }
    }
    
    // need move to new view class
    // Stack
    
    func toggle() {
        if isOpen() {
            close()
        } else {
            open()
        }
    }
    
    func isOpen() -> Bool {
        if mainStack.axis == .vertical {
            return true
        } else {
            return false
        }
    }
    
    func close() {
        stack1.isHidden = true
        stack2.isHidden = true
        stack3.isHidden = true
        textView1.isHidden = true
        
        mainStack.axis = .horizontal
        mainStack.spacing = 30
        mainStack.distribution = .fillEqually
    }
    
    func open() {
        stack1.isHidden = false
        stack2.isHidden = false
        stack3.isHidden = false
        textView1.isHidden = false
        
        self.mainStack.axis = .vertical
        self.mainStack.spacing = 10
        self.mainStack.distribution = .fill
    }


}

