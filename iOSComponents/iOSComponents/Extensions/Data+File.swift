//
//  Data+File.swift
//  FFNN
//
//  Created by Bondar Yaroslav on 23/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension Data {
    init?(file: String) {
        guard let urlPath = Bundle.main.path(for: file) else {
            return nil
        }
        try? self.init(contentsOf: urlPath)
    }
}

extension NSData {
    convenience init?(file: String) {
        guard let urlPath = Bundle.main.path(for: file) else {
            return nil
        }
        self.init(contentsOf: urlPath)
    }
}
