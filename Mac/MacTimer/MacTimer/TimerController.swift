//
//  ViewController.swift
//  MacTimer
//
//  Created by zdaecqze zdaecq on 03.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class TimerController: NSViewController {

    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var timerButton: NSButton!
    var timerStoped = true
    var timer = NSTimer()
    var startTime = NSTimeInterval()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = self
        
        let notification = NSUserNotification(title: "Timer", message: "Come to me, please")
        notification.hasActionButton = true
        notification.actionButtonTitle = "Start"
        //notification.deliveryDate = NSDate(timeIntervalSinceNow: 10000000)
        //notification.userInfo = ["path" : fileName]
        startWithDelay(3) {
            notification.show()
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func updateTimer()  {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        let elapsedTime = currentTime - startTime
        
        let interval = Int(elapsedTime)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        let fraction = Int(elapsedTime * 100) % 100
        timerLabel.stringValue = String(format: "%02d:%02d:%02d:%02d", hours, minutes, seconds, fraction)
    }
    

    @IBAction func actionTimer(sender: NSButton) {
        if timerStoped {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func startTimer() {
        startTime = NSDate.timeIntervalSinceReferenceDate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(TimerController.updateTimer), userInfo: nil, repeats: true)
        timerStoped = false
        timerButton.title = "Stop"
    }
    
    func stopTimer() {
        timer.invalidate()
        //timerLabel.stringValue = "00:00:00:00"
        timerButton.title = "Start"
        timerStoped = true
    }

}

func startWithDelay(delay:Double, closure:()->()) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), closure)
}

extension TimerController: NSUserNotificationCenterDelegate {
    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
        if timerStoped {
            startTimer()
        }
    }
}

extension NSUserNotification {
    convenience init(title: String?, message: String?) {
        self.init()
        self.title = title
        self.informativeText = message
        soundName = NSUserNotificationDefaultSoundName
    }
    
    func show() {
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(self)
    }
}

