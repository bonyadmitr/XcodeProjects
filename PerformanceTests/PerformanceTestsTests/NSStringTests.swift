//
//  NSStringTests.swift
//  PerformanceTestsTests
//
//  Created by Yaroslav Bondar on 14.05.2021.
//  Copyright © 2021 Bondar Yaroslav. All rights reserved.
//

import XCTest
//@testable import PerformanceTests

class NSStringTests: XCTestCase {
    

    override func setUpWithError() throws {
        print()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
}

extension String {
    
    private static let pathChar: String.UTF8View.Element = "/".utf8.first ?? 47
    func lastPathComponent() -> String {
        /// 4.310 sec
        //return self.components(separatedBy: "/").last ?? ""
        let utf = utf8

        if let i = utf.lastIndex(of: Self.pathChar),
           case let nextI = utf.index(i, offsetBy: 1),
           case let suffix = utf.suffix(from: nextI),
           let result = String(suffix)
        {
            return result
        }

        return "/"
        

        
    }
    
}


enum Food {
    case beef
    case broccoli
    case chicken
    case greenPepper
    case lettuce
    case onion
    case redPepper
    case spinach
    case artichoke
    case cabbage
    case celery
    case kale
    case radish
    case squash
    case parsley
    case yellowPepper
    
    func isVegetable() -> Bool {
        return self == .broccoli ||
            self == .greenPepper ||
            self == .lettuce ||
            self == .onion ||
            self == .redPepper ||
            self == .spinach ||
            self == .artichoke ||
            self == .cabbage ||
            self == .celery ||
            self == .kale ||
            self == .radish ||
            self == .squash ||
            self == .parsley ||
            self == .yellowPepper
    }
    
    func isVegetableSwitch() -> Bool {
        switch self {
        case .broccoli, .greenPepper, .lettuce, .onion, .redPepper, .spinach, .artichoke, .cabbage, .celery, .kale, .radish, .squash, .parsley, .yellowPepper:
            return true
        case .beef, .chicken:
            return false
        }
    }

}
