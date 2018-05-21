//
//  UIViewController + Network.swift
//  SwiftBest
//
//  Created by zdaecqze zdaecq on 24.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func startNetwork() {
        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        })
    }
    
    func finishNetwork() {
        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    func blockScreen() {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func unblockScreen() {
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
}
