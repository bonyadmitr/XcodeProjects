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
    
    /// https://stackoverflow.com/a/24552028/5893286
    init?(encodeString: String) {
        guard let encodedString = encodeString.encodingForURL else {
            return nil
        }
        self.init(string: encodedString)
    }
}

private extension String {
    var encodingForURL: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
