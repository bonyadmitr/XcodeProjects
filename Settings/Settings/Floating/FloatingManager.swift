//
//  FloatingManager.swift
//  WindowFloating
//
//  Created by Bondar Yaroslav on 4/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

#if DEBUG
import UIKit

/// https://github.com/remirobert/Dotzu
/// controller can be clearable
final class FloatingManager {
    
    static let shared = FloatingManager()
    private init() {}
    
    private var window: FloatingWindow?
    private let controller = FloatingController()
    
    var presentingController: UIViewController?
    
    var isDisplayedController = false
    var isFloatingViewEnabled = false
    
    func enableFloatingView() {
        if isFloatingViewEnabled {
            return
        }
        isFloatingViewEnabled = true
        setupWindowIfNeed()
    }
    
    private func setupWindowIfNeed() {
        guard window == nil else {
            return
        }
        let newWindow = FloatingWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = controller
        newWindow.makeKeyAndVisible()
        newWindow.delegate = self
        window = newWindow
    }
    
    func disableFloatingView() {
        if !isFloatingViewEnabled {
            return
        }
        isFloatingViewEnabled = false
        window?.isHidden = true
        window = nil
    }
}
extension FloatingManager: FloatingWindowDelegate {
    func isPointEvent(point: CGPoint) -> Bool {
        return controller.shouldReceive(point: point)
    }
}
#endif
