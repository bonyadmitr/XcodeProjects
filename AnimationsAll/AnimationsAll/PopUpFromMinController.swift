//
//  PopUpFromMinController.swift
//  AnimationsAll
//
//  Created by Bondar Yaroslav on 27.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class PopUpFromMinController: UIViewController {
    
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var switchDamping: UISwitch!
    
    var animationTime = 0.3
    var animatedScale: CGFloat = 0.001
    
    //button in controller
    @IBAction func showButton(_ sender: UIButton) {
        view.addSubview(popUpView)
        popUpView.center = view.center
        popUpView.alpha = 0
        popUpView.transform = CGAffineTransform(scaleX: animatedScale, y: animatedScale)
        
        //1
        if switchDamping.isOn {
            UIView.animate(withDuration: animationTime*1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.popUpView.alpha = 1
                self.popUpView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        //2
        else {
            UIView.animate(withDuration: animationTime) {
                self.popUpView.alpha = 1
                self.popUpView.transform = CGAffineTransform.identity
            }
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
