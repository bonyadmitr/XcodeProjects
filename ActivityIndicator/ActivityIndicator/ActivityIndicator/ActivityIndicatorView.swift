//
//  ActivityIndicatorImp.swift
//  ActivityIndicator
//
//  Created by Bondar Yaroslav on 3/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ActivityIndicatorView: UIView {
    
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = #colorLiteral(red: 0.661552785, green: 0.661552785, blue: 0.661552785, alpha: 0.7959672095)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = center
        addSubview(activityIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.center = center
    }
}
extension ActivityIndicatorView: ActivityIndicator {
    func start() {
        activityIndicator.startAnimating()
        alpha = 0
        UIView.animate(withDuration: 0.3) { 
            self.alpha = 1
        }
    }
    
    func stop() { 
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.3) { 
            self.alpha = 0
        }
    }
}
