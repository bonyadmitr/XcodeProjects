//
//  Floating.swift
//  WindowFloating
//
//  Created by Bondar Yaroslav on 4/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class Floating {
    
    enum FloatingMode {
        case shake
        case button
        case none
    }
    
    static var showOnShakeMotion = false
    static var isShownOnShake = false
    
    static var mode: FloatingMode = .button {
        didSet {
            switch mode {
            case .button:
                showOnShakeMotion = false
                FloatingManager.shared.enableFloatingView() 
            case .shake:
                showOnShakeMotion = true
                FloatingManager.shared.disableFloatingView()
            case .none:
                showOnShakeMotion = false
                FloatingManager.shared.disableFloatingView() 
            }
        }
    }
}

#if DEBUG
extension UIWindow {
    override open func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake, Floating.showOnShakeMotion, !Floating.isShownOnShake {
            Floating.isShownOnShake = true
            if let vc = FloatingManager.shared.presentingController {
                rootViewController?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
#endif
