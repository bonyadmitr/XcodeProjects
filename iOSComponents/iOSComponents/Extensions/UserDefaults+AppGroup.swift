//
//  UserDefaults+AppGroup.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 5/15/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension UserDefaults {
    static let appGroupInstance: UserDefaults? = {
        let defaults = UserDefaults(suiteName: "group.com.NAME")
        //defaults?.register(defaults: ["version": "", "build": ""]) /// if need
        return defaults
    }()
}
