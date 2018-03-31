//
//  UIAlertController+Show.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 28/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    convenience init(title: String?, message: String?) {
        self.init(title: title, message: message, preferredStyle: .alert)
        addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    }
    
    convenience init(errorMessage: String?) {
        self.init(title: "Error", message: errorMessage)
    }
    
    static func getAlertControllerWith(title: String?, message: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertController
    }
    
    func show() {
        UIApplication.topController()?.present(self, animated: true, completion: nil)
    }
    
    func showInVC(controller: UIViewController) {
        controller.present(self, animated: true, completion: nil)
    }
}

extension UIApplication {
    
    class func topController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topController(controller: presented)
        }
        return controller
    }
}
