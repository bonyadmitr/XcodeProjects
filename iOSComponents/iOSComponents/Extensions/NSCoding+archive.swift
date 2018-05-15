//
//  NSCoding+archive.swift
//  SwiftBest
//
//  Created by zdaecqze zdaecq on 30.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension NSCoding {
    
    public func archive() -> NSData {
        return NSKeyedArchiver.archivedDataWithRootObject(self)
    }
    
    public static func unarchive(data: NSData) -> Self? {
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Self
    }
}
