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

private final class WokerGlobalActivityIndicator: ActivityIndicatorCounterDelegate {
    
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
}

extension WokerGlobalActivityIndicator: UIBlockable {
    func showIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.start()
            self.window?.addSubview(self.activityIndicator.activityView)
        }
    }
    
    func hideIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stop()
            self.activityIndicator.activityView.removeFromSuperview()
        }
    }
}
