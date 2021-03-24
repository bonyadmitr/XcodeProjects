//
//  DebugOverlay.swift
//  DebugOverlay
//
//  Created by Bondar Yaroslav on 26/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation
import UIKit.UIGestureRecognizerSubclass

/// only singleton bcz of once init
/// need iOS 11
/// need to test for iOS 10
/// inspired https://www.raywenderlich.com/295-swizzling-in-ios-11-with-uidebugginginformationoverlay
final class DebugOverlay {
    static let shared = DebugOverlay()
    
    private let tapGesture = UITapGestureRecognizer()
    private let handler: AnyObject
    
    private init() {
        guard let cls = NSClassFromString("UIDebuggingInformationOverlay") as? UIWindow.Type else {
            print("UIDebuggingInformationOverlay class doesn't exist!")
            handler = NSObject()
            return
        }
        cls.perform(NSSelectorFromString("prepareDebuggingOverlay"))
        
        tapGesture.state = .ended
        
        let handlerCls = NSClassFromString("UIDebuggingInformationOverlayInvokeGestureHandler") as! NSObject.Type
        handler = handlerCls.perform(NSSelectorFromString("mainHandler")).takeUnretainedValue()
    }
    
    func toggleOpen() {
        _ = handler.perform(NSSelectorFromString("_handleActivationGesture:"), with: tapGesture)
    }
}
