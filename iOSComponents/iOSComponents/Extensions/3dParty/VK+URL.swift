//
//  VK+URL.swift
//  VKSwiftyTest
//
//  Created by Bondar Yaroslav on 06/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import SwiftyVK

extension VK {
    static func process(url: URL, with options: [UIApplicationOpenURLOptionsKey: Any]) {
        process(url: url, sourceApplication: options[.sourceApplication] as? String)
    }
}
