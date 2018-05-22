//
//  NSDate+localizedString.swift
//  OrderAppManager
//
//  Created by Nikita Mozhaev on 17.06.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import Foundation

extension NSDate {
    func localizedStringTime()->String {
        return NSDateFormatter.localizedStringFromDate(self, dateStyle: .NoStyle, timeStyle: .ShortStyle)
    }
}