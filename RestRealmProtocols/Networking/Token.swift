//
//  Token.swift
//  Networking
//
//  Created by Bondar Yaroslav on 12.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol Token {
    static var key: String { get }
    static var token: String? { get set }
}
