//
//  BackButtonHandler.swift
//  BackButtonHandler
//
//  Created by Bondar Yaroslav on 2/16/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

public typealias BoolHandler = (Bool) -> Void

public protocol BackButtonHandler {
    func shouldPopOnBackButton(_ handler: @escaping BoolHandler)
}

extension UINavigationController: UINavigationBarDelegate  {
    /// NOTE: this funcion will be called for all pop actions
    /// https://stackoverflow.com/a/43585267
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        /// or maybe need to check: viewControllers.count > 1
        if viewControllers.count < navigationBar.items?.count ?? 0 {
            return true
        }
        
        guard let vc = topViewController as? BackButtonHandler else {
            popVC()
            return true
        }
        
        vc.shouldPopOnBackButton { [weak self] isPopBack in
            if isPopBack {
                self?.popVC()
            } else {
                self?.animateNavigationBar()
            }
        }
        
        return false
    }
    
    private func animateNavigationBar() {
        for subView in navigationBar.subviews {
            if 0 < subView.alpha && subView.alpha < 1 {
                UIView.animate(withDuration: 0.25) {
                    subView.alpha = 1
                }
            }
        }
    }
    
    private func popVC() {
        DispatchQueue.main.async {
            _ = self.popViewController(animated: true)
        }
    }
}
