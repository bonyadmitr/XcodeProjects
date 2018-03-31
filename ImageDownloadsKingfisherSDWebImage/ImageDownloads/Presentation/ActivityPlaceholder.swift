//
//  ActivityPlaceholder.swift
//  ImageDownloads
//
//  Created by Bondar Yaroslav on 07/10/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Kingfisher

class ActivityPlaceholder: UIView {
    let indicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
//        indicator.activityIndicatorViewStyle = .whiteLarge
//        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        addSubview(indicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicator.center = center
    }
    
    deinit {
        print("- ActivityPlaceholder")
    }
}
extension ActivityPlaceholder: Placeholder {
    
}



class MyIndicator: Indicator {
    var view: IndicatorView
    
    init() {
        let v = UIActivityIndicatorView(activityIndicatorStyle: .white)
        v.startAnimating()
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view = v
    }
    
    var viewCenter: CGPoint {
        return view.center
    }
    
    func startAnimatingView() { view.isHidden = false }
    func stopAnimatingView() { view.isHidden = true }
}

