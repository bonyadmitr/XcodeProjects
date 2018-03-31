//
//  TimerLabel.swift
//  Timer
//
//  Created by Bondar Yaroslav on 14/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// Example of vc with TimerLabel
//
//final class TimerControler: UIViewController {
//    @IBOutlet private weak var timerLabel: TimerLabel!
//
//    @IBAction private func actionStartButton(_ sender: UIButton) {
//        start()
//    }
//
//    private func start() {
//        timerLabel.setup(timerLimit: 100, completion: { [weak self] in
//            self?.presentAlert()
//        })
//    }
//
//    func presentAlert() {
//        let vc = UIAlertController(title: "Alert", message: "Timer ended", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        vc.addAction(okAction)
//        present(vc, animated: true, completion: nil)
//    }
//}
final class TimerLabel: UILabel {
    
    private let countdownTimer = CountdownTimer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setMonospacedDigitFont()
    }
    
    func setup(timerLimit: Int, completion: VoidHandler?) {
        countdownTimer.setup(with: 1, timerLimit: timerLimit, stepHandler: { [weak self] timeString in
            self?.text = timeString
            }, completion: completion)
    }
    
    func stopTimer() {
        countdownTimer.stop()
    }
}
