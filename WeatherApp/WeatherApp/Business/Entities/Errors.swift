//
//  Errors.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 29/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

enum Errors {
    case invalidUrl
}
extension Errors: Error {
    var localizedDescription: String {
        switch self {
        case .invalidUrl:
            return "invalidUrl"
        }
    }
}
