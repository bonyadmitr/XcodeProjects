//
//  UIAlertControllerExtensions.swift
//  EZSwiftExtensions
//
//  Created by Lucas Farah on 23/02/16.
//  Copyright (c) 2016 Lucas Farah. All rights reserved.
//
import UIKit

extension UIAlertController {
    
    convenience init(title: String?, message: String?) {
        self.init(title: title, message: message, preferredStyle: .Alert)
        addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
    }
    
    static func getAlertControllerWith(title title: String?, message: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        return alertController
    }
    
    func show() {
        UIApplication.topController.presentViewController(self, animated: true, completion: nil)
    }
    
    func showWithoutHidingKeayboard() {
        var controller = UIApplication.sharedApplication().windows.last!.rootViewController!
        // ---v--- same as topController in extension UIApplication
        while let presentedViewController = controller.presentedViewController {
            controller = presentedViewController
        }
        controller.presentViewController(self, animated: true, completion: nil)
    }
    
    func showInVC(controller: UIViewController) {
        controller.presentViewController(self, animated: true, completion: nil)
    }
}

extension UIApplication {
    
    static var topController : UIViewController {
        var controller = UIApplication.sharedApplication().keyWindow?.rootViewController
        while let presentedViewController = controller!.presentedViewController {
            controller = presentedViewController
        }
        return controller!
    }
}