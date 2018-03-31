//
//  BackendError.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 29/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

final class BackendError: Codable {
    let status: String
    let code: Int
}
extension BackendError: LocalizedError {
    var errorDescription: String? {
        return "\(code) \(status)"
    }
}
