//
//  ViewController.swift
//  BrightnessManager
//
//  Created by Bondar Yaroslav on 15/05/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var brightnessSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brightnessSlider.value = Float(BrightnessManager.shared.value)
        BrightnessManager.shared.delegate = self
    }
    
    @IBAction func brightnessSlider(_ sender: UISlider) {
        BrightnessManager.shared.setValue(sender.value, animated: false)
    }
    @IBAction func someButton(_ sender: UIButton?) {
        BrightnessManager.shared.setValue(0, animated: true)
    }
}
extension ViewController: BrightnessManagerDelegate {
    func brightnessDidChange(value: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.brightnessSlider.setValue(Float(value), animated: true)
        }
    }
    func systemBrightnessSliderDidChange(value: CGFloat) {
        print("systemBrightnessSliderDidChange:", value)
    }
}
