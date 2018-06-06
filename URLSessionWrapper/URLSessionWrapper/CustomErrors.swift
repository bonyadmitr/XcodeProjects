//
//  CustomErrors.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 5/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

enum CustomErrors {
    case system
    case systemDebug(String)
}
extension CustomErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .system:
            return "System error"
        case .systemDebug(let text):
            #if DEBUG
            return text
            #else
            return "System error"
            #endif
        }
    }
}
