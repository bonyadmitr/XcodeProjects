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

/// another solution
/// https://github.com/andreamazz/SubtleVolume

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
    private var systemVolumeObserver: NSObjectProtocol!
    
    required init() {
        slider = SystemVolumeManager.volumeSlider
        addSystemVolumeObserver()
    }
    
    private func addSystemVolumeObserver() {
        systemVolumeObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil, queue: nil)
        { [weak self] notification in
            
            guard let strongSelf = self,
                let userInfo = notification.userInfo,
                let newValue = userInfo["AVSystemController_AudioVolumeNotificationParameter"] as? Float,
                strongSelf.value != newValue
                else { return }
            
            strongSelf.value = newValue
            strongSelf.delegate?.systemVolumeSliderDidChange(value: newValue)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(systemVolumeObserver)
    }
    
    /// can't be use in as instance method bcz of "self"
    private static var volumeSlider: UISlider {
        guard let slider = MPVolumeView().subviews.first as? UISlider else {
            print("SystemVolumeManager error: something went wrong with system volume slider")
            return UISlider()
        }
        return slider
    }
    
    /// need for bar methods
    /// value of one bar
    /// can be set to public
    fileprivate let oneBarValue: Float = 0.0625 // = 1/16
    
    /// max number of bars = 16
    /// maybe need to add
    //let maxBarsNumber = 16
    
    /// need for muting methods
    fileprivate var savedValue: Float?
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
extension UIView {
    fileprivate func addVolumeView() {
        /// also can be set alpha to 0.00001
        let rect = CGRect(x: -20000, y: -20000, width: 0, height: 0)
        let volumeView = MPVolumeView(frame: rect)
        insertSubview(volumeView, at: 0)
    }
    fileprivate func removeVolumeView() {
        let volumeView = subviews.first { $0 is MPVolumeView}
        volumeView?.removeFromSuperview()
    }
}
