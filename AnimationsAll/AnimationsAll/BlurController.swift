//
//  BlurController.swift
//  AnimationsAll
//
//  Created by Bondar Yaroslav on 30/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class BlurController: UIViewController {
    
    let animateTime = 0.5
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.blurView.effect = nil
    }
    
    @IBAction func actionBlurButton(_ sender: UIButton) {
        self.blurView.isHidden = false
        UIView.animate(withDuration: animateTime) {
            self.blurView.effect = UIBlurEffect(style: .light)
        }
    }
    
    @IBAction func actionHideButton(_ sender: UIButton) {
        UIView.animate(withDuration: animateTime, animations: {
            self.blurView.effect = nil
        }, completion: { _ in
            self.blurView.isHidden = true
        })
    }
}
