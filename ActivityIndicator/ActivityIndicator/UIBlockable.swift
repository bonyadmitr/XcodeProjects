//
//  UIBlockable.swift
//  ActivityIndicator
//
//  Created by Bondar Yaroslav on 3/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol UIBlockable: ActivityIndicatorPresenter {
    var activityIndicator: ActivityIndicator { get }
    func showIndicator()
    func hideIndicator()
}
extension UIBlockable {
    func showIndicator() {
        present(activityIndicator: activityIndicator)
    }
    
    func hideIndicator() {
        activityIndicator.stop()
        activityIndicator.activityView.removeFromSuperview()
    }
}
