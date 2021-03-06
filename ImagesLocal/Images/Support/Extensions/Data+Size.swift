//
//  Data+Size.swift
//  Images
//
//  Created by Bondar Yaroslav on 13/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension Data {
    var size: Int64 {
        return Int64(count)
    }
    
    var formattedSize: String {
        return ByteCountFormatter().setup {
            $0.allowedUnits = .useAll
            $0.countStyle = .file
        }.string(fromByteCount: size)
    }
}

enum Formatters {
    static func formattedSize(for size: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
}
