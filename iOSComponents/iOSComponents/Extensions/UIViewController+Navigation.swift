//
//  UIViewController+Navigation.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 16.08.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// EZSwiftExtensions
    public func push(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// EZSwiftExtensions
    public func pop() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    public func popToRoot() {
        navigationController?.popToRootViewControllerAnimated(true) 
    }
    
    /// EZSwiftExtensions
    public func present(vc: UIViewController) {
        presentViewController(vc, animated: true, completion: nil)
    }
}
