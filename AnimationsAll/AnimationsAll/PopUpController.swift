//
//  PopUpController.swift
//  AnimationsAll
//
//  Created by Bondar Yaroslav on 27.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class PopUpController: UIViewController {
    
    @IBOutlet var popUpView: UIView!
    
    var animationTime = 0.3
    var animatedScale: CGFloat = 1.3
    
    //button in controller
    @IBAction func showButton(_ sender: UIButton) {
        view.addSubview(popUpView)
        popUpView.center = view.center
        popUpView.alpha = 0
        popUpView.transform = CGAffineTransform(scaleX: animatedScale, y: animatedScale)
        UIView.animate(withDuration: animationTime) {
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
    }
    
    //button in popUpView
    @IBAction func hideButton(_ sender: UIButton) {
        self.popUpView.alpha = 1
        self.popUpView.transform = CGAffineTransform.identity
        
        UIView.animate(withDuration: animationTime, animations: {
            self.popUpView.alpha = 0
            self.popUpView.transform = CGAffineTransform(scaleX: self.animatedScale, y: self.animatedScale)
        }, completion: { _ in
            self.popUpView.removeFromSuperview()
        })
    }
}
