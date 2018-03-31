//
//  ViewController.swift
//  Timer
//
//  Created by Bondar Yaroslav on 14/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

// TODO: think about restoration timer after viewWillDisappear
final class ViewController: UIViewController {
    
    @IBOutlet private weak var timeLabel: UILabel! {
        didSet {
            timeLabel.setMonospacedDigitFont()
        }
    }
    
    private let countdownTimer = CountdownTimer()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //countdownTimer.stop()
    }
    
    deinit {
        countdownTimer.stop()
        print("- deinit ViewController")
    }
    
    @IBAction private func actionStartButton(_ sender: UIButton) {
        start()
    }
    
    private func start() {
        countdownTimer.setup(with: 1, timerLimit: 100, stepHandler: { [weak self] timeString in
            self?.timeLabel.text = timeString
        }, completion: { [weak self] in
            self?.presentAlert()
        })
    }
    
    private func presentAlert() {
        let vc = UIAlertController(title: "Alert", message: "Timer ended", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        vc.addAction(okAction)
        present(vc, animated: true, completion: nil)
    }
}
