//
//  ViewController.swift
//  SystemVolumeManager
//
//  Created by Bondar Yaroslav on 13/05/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var volumeSlider: UISlider!
    let volumeManager = SystemVolumeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SystemVolumeManager.shared.hideAlert(in: self)
        //volumeManager.hideAlertInAllApp()
        volumeManager.hideAlert(in: self)
        volumeManager.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.19) {
            self.volumeManager.value = 0.1
            print("Volume level = \(self.volumeManager.value)")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.volumeManager.set(bars: 10)
            print("Volume level = \(self.volumeManager.value)")
        }
        
    }
    
    @IBAction func changeSlider(_ sender: UISlider) {
        volumeManager.value = sender.value
        print(volumeManager.currentNumberOfBars)
    }
    
    @IBAction func actionToggleMuteButton(_ sender: UIButton) {
        volumeManager.toggleMute()
    }
    
    deinit {
        print("deinit ViewController")
    }
}
extension ViewController: SystemVolumeManagerDelegate {
    func volumeDidChange(value: Float) {
        UIView.animate(withDuration: 0.3, animations: {
            self.volumeSlider.setValue(value, animated: true)
        })
    }
    func systemVolumeSliderDidChange(value: Float) {
        print("systemVolumeSliderDidChange: ", value)
    }
}

