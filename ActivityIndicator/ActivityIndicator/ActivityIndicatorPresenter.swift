//
//  ActivityIndicatorPresenter.swift
//  ActivityIndicator
//
//  Created by Bondar Yaroslav on 3/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//


/// for history
//import UIKit
//
//protocol ActivityIndicatorPresenter {
//    func present(activityIndicator: ActivityIndicator)
//}
////extension UIViewController: ActivityIndicatorPresenter {
//extension ActivityIndicatorPresenter where Self: UIViewController {
//    func present(activityIndicator: ActivityIndicator) {
//        activityIndicator.activityView.frame = view.bounds
//        activityIndicator.activityView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        activityIndicator.start()
//        view.addSubview(activityIndicator.activityView)
//    }
//}

/// old
//extension UIBlockable {
//    func showIndicator() {
//        present(activityIndicator: activityIndicator)
//    }
//    
//    func hideIndicator() {
//        activityIndicator.stop()
//        activityIndicator.activityView.removeFromSuperview()
//    }
//}
