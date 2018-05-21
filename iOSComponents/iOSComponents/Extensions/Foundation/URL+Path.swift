//
//  URL+Path.swift
//  iGuru
//
//  Created by Yaroslav Bondar on 07.02.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import Foundation

infix operator +/

extension URL {
    static func +/ (lhs: URL, rhs: String) -> URL {
        return lhs.appendingPathComponent(rhs)
    }
}
