//
//  SystemVolumeManager.swift
//  SystemVolumeManager
//
//  Created by Bondar Yaroslav on 11/05/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import MediaPlayer

protocol SystemVolumeManagerDelegate: class {
    func volumeDidChange(value: Float)
    func systemVolumeSliderDidChange(value: Float)
}
extension SystemVolumeManagerDelegate {
    func didChange(value: Float) {}
    func systemVolumeSliderDidChange(value: Float) {}
}

// add button handler or create new class
// http://stackoverflow.com/questions/28471481/swift-detect-volume-button-press
// https://github.com/jpsim/JPSVolumeButtonHandler

/// didn't test for apple rejects
final class SystemVolumeManager {
    
    static let shared = SystemVolumeManager()
    
    /// slider of MPVolumeView
    private let slider: UISlider
    
    /// 0...1
    var value: Float {
        get {
            return slider.value
        }
        set {
            slider.value = newValue
            delegate?.volumeDidChange(value: newValue)
        }
    }
    
    weak var delegate: SystemVolumeManagerDelegate?
    private var systemVolumeObserver: NSObjectProtocol?
    
    init() {
        slider = SystemVolumeManager.volumeSlider
        addSystemVolumeObserver()
    }
    
    private func addSystemVolumeObserver() {
        let notification = NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification")
        systemVolumeObserver = NotificationCenter.default.addObserver(forName: notification, object: nil, queue: nil)
        { [weak self] notification in
            
            guard
                let self = self,
                let userInfo = notification.userInfo,
                let newValue = userInfo["AVSystemController_AudioVolumeNotificationParameter"] as? Float
            else {
                assertionFailure()
                return
            }
            
            if self.value != newValue {
                self.value = newValue
                self.delegate?.systemVolumeSliderDidChange(value: newValue)
            }
        }
    }
    
    deinit {
        guard let systemVolumeObserver = systemVolumeObserver else {
            assertionFailure()
            return
        }
        NotificationCenter.default.removeObserver(systemVolumeObserver)
    }
    
    /// can't be use in as instance method bcz of "self"
    private static var volumeSlider: UISlider {
        guard let slider = MPVolumeView().subviews.first as? UISlider else {
            assertionFailure("SystemVolumeManager error: something went wrong with system volume slider")
            return UISlider()
        }
        return slider
    }
    
    /// need for bar methods
    /// value of one bar
    /// can be set to public
    private let oneBarValue: Float = 0.0625 // = 1/16
    
    /// max number of bars = 16
    /// maybe need to add
    //let maxBarsNumber = 16
    
    /// need for muting methods
    private var savedValue: Float?
}

// MARK: - Bars
extension SystemVolumeManager {
    
    /// return number of burs in system alert
    var currentNumberOfBars: Int {
        /// need this one check bcz value from 0 to (oneBarValue / 2) is one bar in system alert
        if value <= oneBarValue, value != 0 {
            return 1
        }
        return Int(value / oneBarValue)
    }
    
    // maybe need to rename to set(barsNumber bars: Int). and similar methods too.
    /// set number of bars
    ///
    /// max number of bars = 16
    func set(bars: Int) {
        value = Float(bars) * oneBarValue
    }
    
    func add(bars: Int) {
        value += Float(bars) * oneBarValue
    }
    
    func subtract(bars: Int) {
        add(bars: -bars)
    }
    
    func addOneBar() {
        value += oneBarValue
    }
    
    func subtractOneBar() {
        value -= oneBarValue
    }
}

// MARK: - Mute
// TODO: create tests
extension SystemVolumeManager {
    func mute() {
        guard value != 0 else { return }
        savedValue = value
        value = 0
    }
    func unmute() {
        guard let sv = savedValue else { return }
        value = sv
        savedValue = nil
    }
    var isMuted: Bool {
        return value == 0
    }
    func toggleMute() {
        isMuted ? unmute() : mute()
    }
}

// MARK: - AlertInAllApp
extension SystemVolumeManager {
    private var window: UIView? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window
    }
    func hideAlertInAllApp() {
        window?.addVolumeView()
    }
    func restoreAlertInAllApp() {
        window?.removeVolumeView()
    }
}

// MARK: - AlertInVC
extension SystemVolumeManager {
    func hideAlert(in vc: UIViewController) {
        vc.view.addVolumeView()
    }
    func restoreAlert(in vc: UIViewController) {
        vc.view.removeVolumeView()
    }
}

// MARK: - VolumeView extensions
private extension UIView {
    func addVolumeView() {
        /// also can be set alpha to 0.00001
        let rect = CGRect(x: -20000, y: -20000, width: 0, height: 0)
        let volumeView = MPVolumeView(frame: rect)
        insertSubview(volumeView, at: 0)
    }
    func removeVolumeView() {
        let volumeView = subviews.first { $0 is MPVolumeView}
        volumeView?.removeFromSuperview()
    }
}
