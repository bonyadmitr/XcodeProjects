//
//  AnimatedLabelsController.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 15.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class AnimatedLabelsController: UIViewController {

    @IBOutlet weak var someLabel: AnimatedLabel!
    @IBOutlet weak var someLabel2: FadeLabel!
    @IBOutlet weak var someLabel3: SpringLabel!
    
    @IBOutlet weak var countingLabel1: CountingLabel!
    @IBOutlet weak var countingLabel2: CountingLabel!
    @IBOutlet weak var countingLabel3: CountingLabel! {
        didSet {
            countingLabel3.format = "%.3f%%"
        }
    }
    
    @IBAction func actionOKButton(_ sender: UIButton) {
        
        let randomNumber = Float(arc4random_uniform(1000))
        let stringNumber = String(randomNumber)
        someLabel.text = stringNumber
        someLabel2.text = stringNumber
        someLabel3.text = stringNumber
        
        countingLabel1.count(to: stringNumber)
        countingLabel2.count(to: randomNumber, duration: 3, animationType: .easeInOut, countingType: .custom)
        countingLabel3.count(to: randomNumber, duration: 0.3, animationType: .easeInOut, countingType: .custom)
        
    }
}
