//
//  String+String.swift
//  TextFieldHandlers
//
//  Created by Bondar Yaroslav on 5/15/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension String {
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
