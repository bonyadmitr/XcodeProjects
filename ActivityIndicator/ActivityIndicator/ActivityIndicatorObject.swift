//
//  ActivityIndicatorObject.swift
//  ActivityIndicator
//
//  Created by Bondar Yaroslav on 3/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ActivityIndicatorObject {
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    init() {
        activityIndicator.hidesWhenStopped = true
    }
}
extension ActivityIndicatorObject: ActivityIndicator {
    var activityView: UIView {
        return activityIndicator
    }
    
    func start() {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stop() { 
        activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
    }
}
