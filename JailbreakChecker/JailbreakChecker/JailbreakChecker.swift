//
//  JailbreakChecker.swift
//  JailbreakChecker
//
//  Created by Bondar Yaroslav on 3/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// optimized from
/// https://stackoverflow.com/questions/413242/how-do-i-detect-that-an-ios-app-is-running-on-a-jailbroken-phone/413951
final class JailbreakChecker {
    
    private let list: [String] = ["/Applications/Cydia.app",
                                  "/Library/MobileSubstrate/MobileSubstrate.dylib",
                                  "/bin/bash",
                                  "/usr/sbin/sshd",
                                  "/etc/apt",
                                  "/private/var/lib/apt/",
                                  "/usr/bin/ssh"]
    
    var isJailbroken: Bool {
        
        if isSimulator {
            return false
        }
        
        for path in list {
            if FileManager.default.fileExists(atPath: path) || canOpen(path: path) {
                return true
            }   
        }
        
        let path = "/private/" + UUID().uuidString
        do {
            try "anyString".write(toFile: path, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    private func canOpen(path: String) -> Bool {
        guard let file = fopen(path, "r") else {
            return false
        }
        fclose(file)
        return true
    }
    
    private var isSimulator: Bool {
        return TARGET_IPHONE_SIMULATOR == 1
    }
}

