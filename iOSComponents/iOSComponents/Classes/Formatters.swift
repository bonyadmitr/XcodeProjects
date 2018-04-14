//
//  Formatters.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

final class Formatters {
    
    static func bytes(from bytes: Int64) -> String {
        /// bytes only
//        let formatter = ByteCountFormatter()
//        formatter.allowedUnits = .useMB
//        formatter.countStyle = .decimal
//        formatter.includesUnit = false
//        return formatter.string(fromByteCount: bytes)
        return ByteCountFormatter.string(fromByteCount: bytes, countStyle: .binary)
    }
    
    func minutesSecond(from value: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: value) ?? ""
    }
    
    func minutesSecond(from value: Int) -> String {
        let minutes = value / 60
        let seconds = value % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
