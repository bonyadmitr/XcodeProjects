//
//  FormattersTest.swift
//  Images
//
//  Created by Bondar Yaroslav on 13/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// TARGET IS OFF FOR THIS FILE

final class FormattersGlobalTest {
    private init() {}

    /// 1
    static var byte: ByteCountFormatter {
        return ByteCountFormatter().setup {
            $0.allowedUnits = .useAll
            $0.countStyle = .file
        }
    }

    /// 2
//    static let byte = ByteCountFormatter().setup {
//        $0.allowedUnits = .useAll
//        $0.countStyle = .file
//    }
}

