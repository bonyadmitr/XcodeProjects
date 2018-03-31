//
//  PasscodeManager.swift
//  Passcode
//
//  Created by Bondar Yaroslav on 10/4/17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol PasscodeEnterDelegate: class {
    func finishPasscode()
}

final class PasscodeManager {
    
    let passcodeStorage = PasscodeStorageDefaults()
    weak var delegate: PasscodeEnterDelegate?
    
    var isOn: Bool = false {
        didSet {
            if isOn {
                show(with: .new)
            } else {
                show(with: .validate)
            }
        }
    }
    
    lazy var window: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = UIWindowLevelStatusBar + 1
        return window
    }()
    
    lazy var controller: PasscodeController = {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! PasscodeController
        vc.delegate = self
        return vc
    }()
    
    init() {
        window.rootViewController = controller
    }
    
    func show(with type: PasscodeInputViewType = .validate) {
        if isOn {
            controller.type = type
            window.makeKeyAndVisible()
        }
    }
    
    func hide() {
        window.isHidden = true
    }
}
extension PasscodeManager: PasscodeViewDelegate {
    func finishSetNew(passcode: Passcode) {
        passcodeStorage.save(passcode: passcode)
        delegate?.finishPasscode()
        hide()
    }
    func finishValidate() {
        delegate?.finishPasscode()
        hide()
        
//        if !isOn {
//            passcodeStorage.clearPasscode()
//        }
    }
    func check(passcode: Passcode) -> Bool {
        return passcodeStorage.isEqual(to: passcode)
    }
}


//import UIKit
//public final class NotificationBanner {
//
//    static let shared = NotificationBanner()
//
//    // MARK: - Properties Public
//
//    public lazy var didPressBanner: () -> () = {}
//    public lazy var didPressHideButton: () -> () = { }
//    public var autoHideTimer = 2
//
//    // MARK: - Properties Private
//
//    private var count = 0
//    private var timer: NSTimer?
//
//    private lazy var window: UIWindow! = {
//        return self.getWindow()
//    }()
//
//    private func getWindow() -> UIWindow {
//        let window = UIWindow()
//        window.rootViewController = self.controller
//        let bannerFrame = CGRect(x: 0, y: -self.height, width: UIScreen.mainScreen().bounds.width, height: self.height)
//        window.frame = bannerFrame
//        self.controller.view.frame = bannerFrame
//        window.windowLevel = UIWindowLevelStatusBar + 1
//        window.backgroundColor = UIColor.clearColor()
//        return window
//    }
//
//    private lazy var controller: NotificationBannerController = {
//        let controller = NotificationBannerController(nibName: "NotificationBannerController", bundle: nil)
//        controller.didPressBanner = {
//            self.hideBanner()
//            self.didPressBanner()
//        }
//        controller.didPressHideButton = {
//            self.hideBanner()
//            self.didPressHideButton()
//        }
//        return controller
//    }()
//
//    private lazy var height: CGFloat = {
//        return self.controller.view.bounds.height
//    }()
//
//
//    // MARK: - Timer functions Private
//
//    @objc private func timerTick() {
//        count -= 1
//        if count < 1 {
//            self.hideBanner()
//        }
//    }
//
//    private func startTimer() {
//        if autoHideTimer > 0 {
//            count = autoHideTimer
//            timer?.invalidate()
//            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(NotificationBanner.timerTick), userInfo: nil, repeats: true)
//        }
//    }
//
//    // MARK: - Banner Functions Private
//
//    private func hideBanner() {
//        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut,
//                                   animations: {
//                                    self.window.frame.origin.y = -self.height
//        }, completion: { bool in
//            self.window.hidden = true
//        }
//        )
//        timer?.invalidate()
//    }
//
//    // MARK: - Banner Functions Public
//
//    public func show(title title: String? = nil, message: String? = nil) {
//        if window.hidden {
//            window.hidden = false
//            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
//                self.window.frame.origin.y = CGFloat(0)
//            }, completion: nil)
//
//        }
//        controller.titleLabel.text = title
//        controller.messageLabel.text = message
//
//        startTimer()
//    }
//
//    public func releaseMemory() {
//        window = nil
//    }
//    public func initAgain() {
//        window = getWindow()
//    }
//}
