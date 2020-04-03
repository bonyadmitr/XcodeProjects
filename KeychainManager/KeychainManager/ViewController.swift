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
        print(keychainManager.clear())
        
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
    
    func allKeys() -> [String] {
        let query = [
            kSecClass : kSecClassGenericPassword,
            kSecReturnData : true,
            kSecReturnAttributes: true,
            kSecReturnRef: true,
            kSecMatchLimit: kSecMatchLimitAll
        ] as [CFString: Any]
        
        //      query = addAccessGroupWhenPresent(query)
        //      query = addSynchronizableIfRequired(query, addingItems: false)
        
        var itemsQueries: AnyObject?
        
        let status = withUnsafeMutablePointer(to: &itemsQueries) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if status == errSecSuccess {
            return (itemsQueries as? [[CFString: Any]])?.compactMap {
                $0[kSecAttrAccount] as? String } ?? []
        }
        
        return []
    }
    
    @discardableResult
    func clear() -> Bool {
      let query: [CFString: Any] = [kSecClass : kSecClassGenericPassword ]
//      query = addAccessGroupWhenPresent(query)
//      query = addSynchronizableIfRequired(query, addingItems: false)
//      lastQueryParameters = query
      
      let lastResultCode = SecItemDelete(query as CFDictionary)
      
      return lastResultCode == errSecSuccess || lastResultCode == errSecItemNotFound
    }
}
