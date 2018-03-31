//
//  Injection+Controllers.swift
//  InjectionTest
//
//  Created by Bondar Yaroslav on 11/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIViewController {
    func injected() {
        print("I've been injected: \(self)")
//        view.subviews.forEach {
//            $0.removeFromSuperview()
//        }
        viewDidLoad()
    }
}

extension UITableViewController {
    override func injected() {
        super.injected()
        tableView.reloadData()
    }
}
