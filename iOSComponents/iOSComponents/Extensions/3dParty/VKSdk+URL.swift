//
//  VKSdk+URL.swift
//  VKTest
//
//  Created by Bondar Yaroslav on 06/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import VKSdkFramework

extension VKSdk {
    static func process(url: URL, with options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        guard let appString = options[.sourceApplication] as? String else {
            return false
        }
        return VKSdk.processOpen(url, fromApplication: appString)
    }
}
