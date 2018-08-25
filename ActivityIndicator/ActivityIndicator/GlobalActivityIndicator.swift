//
//  GlobalActivityIndicator.swift
//  ActivityIndicator
//
//  Created by Bondar Yaroslav on 8/24/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class GlobalActivityIndicator {
    
    private static let woker = WokerGlobalActivityIndicator()
    
    static func show() {
        woker.activityIndicatorCounter.start()
    }
    static func hide() {
        woker.activityIndicatorCounter.stop()
    }
}

private final class WokerGlobalActivityIndicator: ActivityIndicatorCounterDelegate, UIBlockable {
    
    let activityIndicator: ActivityIndicator = ActivityIndicatorView()
    lazy var activityIndicatorCounter = ActivityIndicatorCounter(delegate: self)
    
    private var window: UIWindow? 
    
    init() {
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else {
            return
        }
        activityIndicator.activityView.frame = window.bounds
        activityIndicator.activityView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.window = window
    }
    
    func showIndicator() {
        activityIndicator.start()
        window?.addSubview(activityIndicator.activityView)
    }
    
    func hideIndicator() {
        activityIndicator.stop()
        activityIndicator.activityView.removeFromSuperview()
    }
}
