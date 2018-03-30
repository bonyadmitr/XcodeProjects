//
//  BackgroundController.swift
//  Customization
//
//  Created by Bondar Yaroslav on 20/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// need Images.background
class BackgroundController: UIViewController {
    
    lazy var backImageView: UIImageView? = {
        let iv = UIImageView(frame: self.view.bounds)
        iv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        iv.image = Images.background
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.insertSubview(backImageView!, at: 0)
    }
}
