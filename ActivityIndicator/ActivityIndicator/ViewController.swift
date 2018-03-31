//
//  ViewController.swift
//  ActivityIndicator
//
//  Created by Bondar Yaroslav on 3/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ActivityIndicatorCounterController, UIBlockable {
    
    /// or 1
//    lazy var activityIndicator: ActivityIndicator = ActivityIndicatorView()
    /// or 2
    lazy var activityIndicator: ActivityIndicator = ActivityIndicatorObject()
    
    lazy var activityIndicatorCounter = ActivityIndicatorCounter(controller: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let start: Double = 2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + start) { [weak self] in 
            self?.activityIndicatorCounter.start()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + start + 1) { [weak self] in
            /// first start, then stop, to continue activityIndicator 
            self?.activityIndicatorCounter.start()
            self?.activityIndicatorCounter.stop()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + start + 2) { [weak self] in 
            self?.activityIndicatorCounter.stop()
        }
    }
}
