//
//  SplitControllerKeyCommand.swift
//  SplitController
//
//  Created by Bondar Yaroslav on 8/9/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

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
