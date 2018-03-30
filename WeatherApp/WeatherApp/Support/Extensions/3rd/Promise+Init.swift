//
//  Promise+Init.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 29/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import PromiseKit

extension Promise {
    convenience init(value: T?, or error: Error) {
        guard let value = value else {
            self.init(error: error)
            return
        }
        self.init(value: value)
    }
}
