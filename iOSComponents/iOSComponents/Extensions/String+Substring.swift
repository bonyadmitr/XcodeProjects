//
//  String+Substring.swift
//  Swift3Best
//
//  Created by Bondar Yaroslav on 21/01/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (i: Int) -> String.Index {
        return self.index( self.startIndex, offsetBy: i)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[Range(start ..< end)])
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        let currentString = self as NSString
        return currentString.appendingPathComponent(path)
    }
    
    func removingWhiteSpaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
}
