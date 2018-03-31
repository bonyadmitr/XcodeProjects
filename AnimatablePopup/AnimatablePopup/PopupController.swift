//
//  PopupController.swift
//  AnimatablePopup
//
//  Created by Bondar Yaroslav on 3/22/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class PopupController: UIViewController, AnimatablePopup {
    
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.backgroundColor = #colorLiteral(red: 0.7174546632, green: 0.7174546632, blue: 0.7174546632, alpha: 0.5163127201)
        }
    }
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.masksToBounds = true
            containerView.layer.cornerRadius = 5
        }
    }
    
    var isShown = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        open()
    }
    
    @IBAction func actionCloseButton(_ sender: UIButton) {
        close() {
            print("closed")
        }
    }
    
    deinit {
        print("- deinit PopupController")
    }
}
