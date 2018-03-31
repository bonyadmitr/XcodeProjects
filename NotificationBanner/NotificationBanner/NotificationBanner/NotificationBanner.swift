//
//  NotificationBanner.swift
//  NotificationBanner
//
//  Created by zdaecqze zdaecq on 13.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

public final class NotificationBanner {
    
    // MARK: - Properties Public
    
    public lazy var didPressBanner: () -> () = {}
    public lazy var didPressHideButton: () -> () = { }
    public var autoHideTimer = 2
    
    // MARK: - Properties Private
    
    private var count = 0
    private var timer: NSTimer?
    
    private lazy var window: UIWindow! = {
        return self.getWindow()
    }()
    
    private func getWindow() -> UIWindow {
        let window = UIWindow()
        window.rootViewController = self.controller
        window.frame = CGRect(x: 0, y: -self.height, width: UIScreen.mainScreen().bounds.width, height: self.height)
        window.windowLevel = UIWindowLevelStatusBar + 1
        window.backgroundColor = UIColor.clearColor()
        return window
    }
    
    private lazy var controller: NotificationBannerController = {
        let controller = NotificationBannerController(nibName: "NotificationBannerController", bundle: nil)
        controller.didPressBanner = {
            self.hideBanner()
            self.didPressBanner()
        }
        controller.didPressHideButton = {
            self.hideBanner()
            self.didPressHideButton()
        }
        return controller
    }()
    
    private lazy var height: CGFloat = {
        return self.controller.view.bounds.height
    }()
    
    
    // MARK: - Timer functions Private
    
    @objc private func timerTick() {
        count -= 1
        if count < 1 {
            self.hideBanner()
        }
    }
    
    private func startTimer() {
        if autoHideTimer > 0 {
            count = autoHideTimer
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(NotificationBanner.timerTick), userInfo: nil, repeats: true)
        }
    }
    
    // MARK: - Banner Functions Private
    
    private func hideBanner() {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut,
            animations: {
                self.window.frame.origin.y = -self.height
            }, completion: { bool in
                self.window.hidden = true
            }
        )
        timer?.invalidate()
    }
    
    // MARK: - Banner Functions Public
    
    public func show(title title: String? = nil, message: String? = nil) {
        if window.hidden {
//            window.makeKeyAndVisible()
            window.hidden = false
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
                self.window.frame.origin.y = CGFloat(0)
                }, completion: nil)

        }
        controller.titleLabel.text = title
        controller.messageLabel.text = message
        
        startTimer()
    }
    
    public func releaseMemory() {
        window = nil
    }
    public func initAgain() {
        window = getWindow()
    }
}
