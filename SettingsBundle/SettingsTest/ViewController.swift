//
//  ViewController.swift
//  SettingsTest
//
//  Created by Bondar Yaroslav on 01/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var slider1: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        print("isSimulator:", UIDevice.current.isSimulator)
        
        let sliderValue = UserDefaults.standard.float(forKey: SettingsManager.shared.sliderKey)
        slider1.setValue(sliderValue, animated: true)
        
        UserDefaults.standard.addObserver(self, forKeyPath: SettingsManager.shared.sliderKey, options: .new, context: nil)
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: SettingsManager.shared.sliderKey)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath != SettingsManager.shared.sliderKey {
            return
        }
        let sliderValue = UserDefaults.standard.float(forKey: SettingsManager.shared.sliderKey)
        slider1.setValue(sliderValue, animated: true)
    }
    
    @IBAction func actionSettingsButton(_ sender: UIButton) {
        UIApplication.shared.openSettings()
    }
    
    /// "Touch Up Inside" and "Touch up outside" actions
    @IBAction func actionSlider(_ sender: UISlider) {
        UserDefaults.standard.set(sender.value, forKey: SettingsManager.shared.sliderKey)
    }
}
