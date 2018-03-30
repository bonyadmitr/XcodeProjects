//
//  String+Substring.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
extension String {
    private func index(from: Int) -> Index {
        return index(startIndex, offsetBy: from)
    }
    
    subscript(i: Int) -> Character {
        return self[index(from: i)]
    }
    
    //    subscript(iStr i: Int) -> String {
    //        return String(self[i] as Character)
    //    }
    
    
    subscript(from i: Int) -> String {
        return substring(from: index(from: i))
    }
    
    subscript(to i: Int) -> String {
//        self[..<3]
        return substring(to: index(from: i))
    }
    
    subscript(r: CountableRange<Int>) -> String {
        let start = index(from: r.lowerBound)
        let end = index(from: r.upperBound)
        return String(self[start..<end])
    }
    
    subscript(r: CountableClosedRange<Int>) -> String {
        return self[CountableClosedRange(r)]
    }

}
// swiftlint:enable identifier_name
