//
//  ViewController.swift
//  DynamicFont
//
//  Created by Bondar Yaroslav on 5/4/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIFont {
    func dynamic(for textStyle: UIFont.TextStyle = .body) -> UIFont {
        //UIFontMetrics.default
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        return fontMetrics.scaledFont(for: self)
    }
}


class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

