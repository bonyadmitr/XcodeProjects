//
//  SplitController.swift
//  SplitController
//
//  Created by Bondar Yaroslav on 8/7/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// https://nshipster.com/uikeycommand/
/// https://stablekernel.com/creating-a-delightful-user-experience-with-ios-keyboard-shortcuts/
class SplitController: UISplitViewController, Multicaster {
    
    var delegates = MulticastDelegate<SplitControllerKeyCommandDelegate>()
    
    /// input: "\u{8}" for backspace(delete) key
    /// https://stackoverflow.com/a/27608606
    private lazy var privateLazyKeyCommands = [SplitControllerKeyCommand.one, .two, .three, .four, .f].map { keyComand in
        UIKeyCommand(input: keyComand.rawValue,
                     modifierFlags: .command,
                     action: #selector(keyCommandPressed),
                     discoverabilityTitle: keyComand.discoverabilityTitle)
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return privateLazyKeyCommands
    }
    
    @objc private func keyCommandPressed(_ sender: UIKeyCommand) {
        guard let keyinput = sender.input, let keyCommand = SplitControllerKeyCommand(rawValue: keyinput) else {
            return
        }
        
        if keyCommand == .f {
            toggleDisplayMode()
        }
        
        delegates.invoke { $0.didPressed(keyCommand: keyCommand) }
    }
}

protocol SplitControllerKeyCommandDelegate: class {
    func didPressed(keyCommand: SplitControllerKeyCommand)
}
extension SplitControllerKeyCommandDelegate {
    func didPressed(keyCommand: SplitControllerKeyCommand) {}
}
