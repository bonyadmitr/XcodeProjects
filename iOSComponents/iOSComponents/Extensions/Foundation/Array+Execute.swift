//
//  Array+Execute.swift
//  Customization
//
//  Created by Bondar Yaroslav on 20/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// Example
///view.subviews
///    .execute { updateAllLabeles(in: $0, with: fontName) }
///    .flatMap { $0 as? UILabel }
///    .forEach { $0.font = UIFont(name: fontName, size: $0.font.pointSize) }
///
extension Array {
    /// forEach with return of self
    func execute(_ body: (Element) throws -> Void) rethrows -> [Element] {
        try self.forEach { try body($0) }
        return self
    }
}
