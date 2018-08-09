//
//  SplitController.swift
//  SplitController
//
//  Created by Bondar Yaroslav on 8/7/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

enum SplitControllerKeyCommand: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case f = "f"
}
extension SplitControllerKeyCommand {
    var discoverabilityTitle: String {
        let title: String
        switch self {
        case .one:
            title = "Row 1"
        case .two:
            title = "Row 2"
        case .three:
            title = "Row 3"
        case .four:
            title = "Row 4"
        case .f:
            title = "Toggle fullscreen"
        }
        return title
    }
    
}

protocol SplitControllerKeyCommandDelegate: class {
    func didPressed(keyCommand: SplitControllerKeyCommand)
}
extension SplitControllerKeyCommandDelegate {
    func didPressed(keyCommand: SplitControllerKeyCommand) {}
}

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
