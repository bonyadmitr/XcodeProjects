//
//  StatusBarActions.swift
//  Interview
//
//  Created by Bondar Yaroslav on 5/21/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol StatusBarActions {
    
}
extension BackButtonActions where Self: UIViewController {
    
    /// https://stackoverflow.com/a/43264566
    func addViewToSetStatusBarBackgroundColor(_ color: UIColor) {
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = color
        
        /// need insert(not add) for landscape vc to not see it
        /// (there is no status bar in landscape by default)
        view.insertSubview(statusBarView, at: 0)
    }
}
