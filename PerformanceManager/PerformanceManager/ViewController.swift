//
//  ViewController.swift
//  PerformanceManager
//
//  Created by Bondar Yaroslav on 5/22/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

// TODO: window
// https://github.com/dani-gavrilov/GDPerformanceView-Swift/blob/master/GDPerformanceView-Swift/GDPerformanceMonitoring/PerformanceView.swift

final class ViewController: UIViewController {

    private let performanceManager = PerformanceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        performanceManager.start()
    }
    
    deinit {
        print("deinit ViewController")
        performanceManager.stop()
    }
}
