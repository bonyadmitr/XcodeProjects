//
//  ViewController.swift
//  KeychainManager
//
//  Created by Bondar Yaroslav on 4/3/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let keychainManager = KeychainManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(keychainManager.allKeys())
        
        let value = "some 12".data(using: .utf8)!
        let key = "key1"
        if let data = keychainManager.object(for: key), let str = String(data: data, encoding: .utf8) {
            print(str)
        }
        
        keychainManager.save(key: key, data: value)
    }


}

final class KeychainManager {
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unhandledError(status: OSStatus)
    }
    
    @discardableResult
    func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            Keys.attrAccount : key,
            kSecValueData as String: data,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
        ] as CFDictionary
        
        print(SecItemDelete(query))
        //errSecItemNotFound
        // -25300
        
        let status = SecItemAdd(query, nil)
        //errSecDuplicateItem
        //-25299
        print("- save(key \(status)")
        if status == errSecSuccess {
            
        } else {
            
        }
        return status
    }
    
    enum Keys {
        static let attrAccount = kSecAttrAccount as String
    }
    
    func object(for key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount : key,
            kSecReturnData : kCFBooleanTrue as Any,
            kSecMatchLimit : kSecMatchLimitOne,
//            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
        ] as [CFString: Any]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        //errSecSuccess
        //noErr
        /// errSecSuccess == noErr
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            print("- error object(for key \(status)")
            return nil
        }
    }
    
}
