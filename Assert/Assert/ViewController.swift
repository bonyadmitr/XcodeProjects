//
//  ViewController.swift
//  Assert
//
//  Created by Bondar Yaroslav on 8/30/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testDispatchAssert()
        
        view.backgroundColor = .lightGray
        print("- viewDidLoad")
    }

    func testDispatchAssert() {
        
        if #available(iOS 10.0, *) {
            dispatchAssert(condition: .onQueue(.main))
        }
        
        assertMainQueue()
        
        DispatchQueue.global().async {
            assertBackgroundQueue()
        }
    }
}

