//
//  ViewController.swift
//  Optionals
//
//  Created by Bondar Yaroslav on 01/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text: String? = nil
        
        print("isNil: ", text.isNil)
        print("isSome: ", text.isSome)
        print("text.or: ", text.or("some text"))
        print("text.or: ", text.or(else: "so me text" + " 123"))
        
        text.on(none: print("on(none: ", "none 1"))
        text.on(none: { print("on(none: ", "none 2") })
        
        text.on(some: print("on(some: ", "some "))
    }
}
