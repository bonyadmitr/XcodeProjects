//
//  ViewController.swift
//  UnitTestsCoreData
//
//  Created by Bondar Yaroslav on 11/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        CoreDataStack.shared.newBackgroundContext()
    }


}

