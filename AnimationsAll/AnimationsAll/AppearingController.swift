//
//  AppearingController.swift
//  AnimationsAll
//
//  Created by Bondar Yaroslav on 27.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class AppearingController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var button1: SomeRoundButton!
    @IBOutlet weak var button2: SomeRoundButton!
    @IBOutlet weak var hideButton: SomeRoundButton!
    
    let time = 0.3
    
    var savedFrame1: CGRect!
    var savedFrame2: CGRect!
    var savedFrame3: CGRect!
    
    var animateOnFirstAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        _ = UIEdgeInsets(top: 10, left: 1, bottom: 10, right: 1)
        
//        view.layoutIfNeeded()
        
        //different frame for included views
        
        savedFrame1 = button1.frame
        button1.frame = CGRect(x: -button1.frame.width, y: button1.frame.origin.y,
                               width: button1.frame.width, height: button1.frame.height)
        
        savedFrame2 = button2.frame
        button2.frame = CGRect(x: view.frame.width, y: button2.frame.origin.y,
                               width: button2.frame.width, height: button2.frame.height)
        
        savedFrame3 = hideButton.frame
        hideButton.frame = CGRect(x: hideButton.frame.origin.x, y: view.frame.height,
                                  width: hideButton.frame.width, height: hideButton.frame.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !animateOnFirstAppear {
            UIView.animate(withDuration: time) {
                self.button1.frame = self.savedFrame1
                self.button2.frame = self.savedFrame2
            }
            
            UIView.animate(withDuration: time, delay: time-0.2, options: .curveEaseInOut, animations: {
                self.hideButton.frame = self.savedFrame3
            }, completion: nil)
            
            animateOnFirstAppear = true
        }
    }
}
