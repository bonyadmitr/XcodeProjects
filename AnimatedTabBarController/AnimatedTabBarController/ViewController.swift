//
//  ViewController.swift
//  AnimatedTabBarController
//
//  Created by Bondar Yaroslav on 8/9/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension UITabBarItem {
    
    /// UITabBarButton
    var view: UIControl? {
        return value(forKey: "view") as? UIControl
    }
    
    /// inspired https://stackoverflow.com/a/45320350/5893286
    var badgeView: UIView? {
        return view?.subviews.first { String(describing: type(of: $0)) == "_UIBadgeView" }
    }
    
}
