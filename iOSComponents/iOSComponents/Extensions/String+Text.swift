//
//  String+Text.swift
//  iGuru
//
//  Created by Yaroslav Bondar on 17.01.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import UIKit

extension String {
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
