//
//  SplitController.swift
//  SplitController
//
//  Created by Bondar Yaroslav on 8/7/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class SplitController: UISplitViewController {
    
    /// input: "\u{8}" for backspace(delete) key
    /// https://stackoverflow.com/a/27608606
    private lazy var privateLazyKeyCommands = [
        UIKeyCommand(input: "1", modifierFlags: .command, action: #selector(selectTab), discoverabilityTitle: "Types"),
        UIKeyCommand(input: "2", modifierFlags: .command, action: #selector(selectTab), discoverabilityTitle: "Protocols"),
        UIKeyCommand(input: "3", modifierFlags: .command, action: #selector(selectTab), discoverabilityTitle: "Functions"),
        UIKeyCommand(input: "4", modifierFlags: .command, action: #selector(selectTab), discoverabilityTitle: "Operators"),
        UIKeyCommand(input: "f", modifierFlags: [.command], action: #selector(selectTab), discoverabilityTitle: "Full screen")
    ]
    
    override var keyCommands: [UIKeyCommand]? {
        return privateLazyKeyCommands
    }
    
    @objc private func selectTab(_ sender: UIKeyCommand) {
        guard let keyinput = sender.input else {
            return
        }
        
        if keyinput == "f" {
            toggleDisplayMode()
        }
    }
}


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
