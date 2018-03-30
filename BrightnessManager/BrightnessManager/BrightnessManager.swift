//
//  BrightnessManager.swift
//  BrightnessManager
//
//  Created by Bondar Yaroslav on 15/05/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol BrightnessManagerDelegate: class {
    func brightnessDidChange(value: CGFloat)
    func systemBrightnessSliderDidChange(value: CGFloat)
}
extension BrightnessManagerDelegate {
    func brightnessDidChange(value: CGFloat) {}
    func systemBrightnessSliderDidChange(value: CGFloat) {}
}

/// NSObject need for perform selector method
class BrightnessManager: NSObject {
    
    static let shared = BrightnessManager()
    
    private var savedValue: CGFloat = 0
    
    private var brightnessObserver: NSObjectProtocol!
    
    weak var delegate: BrightnessManagerDelegate?
    
    var value: CGFloat {
        get {
            return UIScreen.main.brightness
        }
        set {
            UIScreen.main.brightness = newValue
            delegate?.brightnessDidChange(value: newValue)
        }
    }
    
    override init() {
        super.init()
        addBrightnessObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(brightnessObserver)
    }
    
    /// Don't use animated: true for slider, will be not good animation of slider
    /// 0...1.0, where 1.0 is maximum brightness.
    func setValue(_ value: Float, animated: Bool) {
        let value = CGFloat(value)
        if animated {
            savedValue = value
            setBrightnessAnimated()
        } else {
            self.value = value
        }
    }
    
    func addBrightnessObserver() {
        brightnessObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UIScreenBrightnessDidChangeNotification"), object: nil, queue: nil)
        { [weak self] notification in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.systemBrightnessSliderDidChange(value: strongSelf.value)
            strongSelf.delegate?.brightnessDidChange(value: strongSelf.value)
        }
    }
    
    @objc fileprivate func setBrightnessAnimated() {
        if abs(value - savedValue) < 0.001 { return }
        value += value < savedValue ? 0.01 : -0.01
        perform(#selector(BrightnessManager.setBrightnessAnimated), with: nil, afterDelay: 0.01)
    }
}
