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
