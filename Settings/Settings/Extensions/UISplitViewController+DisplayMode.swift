//
//  UISplitViewController+DisplayMode.swift
//  Settings
//
//  Created by Bondar Yaroslav on 11/7/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UISplitViewController {
    func toggleDisplayMode() {
        guard let mode = delegate?.targetDisplayModeForAction?(in: self) else {
            toggleDisplayModeManual()
            return
        }
        
        /// 0.3 is too may for this animation
        UIView.animate(withDuration: 0.2) {
            self.preferredDisplayMode = mode
        }
    }
    
    func toggleDisplayModeManual() {
        UIView.animate(withDuration: 0.2) {
            if self.displayMode == .allVisible {
                self.preferredDisplayMode = .primaryHidden
            } else {
                self.preferredDisplayMode = .allVisible
            }
        }
    }
}
