//
//  NSExtensionContext+URL.swift
//  TodayExtensionTest
//
//  Created by Bondar Yaroslav on 09/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension NSExtensionContext {
    func open(_ scheme: String) {
        if let url = URL(string: scheme) {
            open(url)
        }
    }
}
