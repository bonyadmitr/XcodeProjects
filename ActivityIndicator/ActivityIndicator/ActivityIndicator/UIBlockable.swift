//
//  UIBlockable.swift
//  ActivityIndicator
//
//  Created by Bondar Yaroslav on 3/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol UIBlockable {
    var activityIndicator: ActivityIndicator { get }
    func showIndicator()
    func hideIndicator()
}
extension UIBlockable where Self: UIViewController {
    func showIndicator() {
        activityIndicator.activityView.frame = view.bounds
        activityIndicator.activityView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        activityIndicator.start()
        view.addSubview(activityIndicator.activityView)
    }
    
    func hideIndicator() {
        activityIndicator.stop()
        activityIndicator.activityView.removeFromSuperview()
    }
}
