//
//  ViewController.swift
//  Singleton
//
//  Created by Bondar Yaroslav on 14/05/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionClearButton(_ sender: UIButton) {
        SomeClass.shared.value += "qwe"
        SomeClass2.shared.value += "Q"
        
        print(SomeClass.shared.value)
        print(SomeClass2.shared.value)
        
        SomeClass.clearShared()
        //SomeClass2.clearShared()
    }
}

final class SomeClass: ClearableSingleton {
    var value = ""
    deinit { print("D SomeClass") }
}

final class SomeClass2: ClearableSingleton {
    var value = ""
    deinit { print("D SomeClass2") }
}
