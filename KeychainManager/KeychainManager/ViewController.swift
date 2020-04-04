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
        
        
        print("all:", keychainManager.allKeys())
        //print(keychainManager.clear())
        
        let value = "some 12".data(using: .utf8)!
        let key = "key1"
        if let data = keychainManager.get(for: key), let str = String(data: data, encoding: .utf8) {
            print(str)
        }
        
        keychainManager.set(value, for: key)
    }

}

final class KeychainManager {
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unhandledError(status: OSStatus)
    }
    
    @discardableResult
    func set(_ data: Data, for key: String) -> OSStatus {
        var query = [
            kSecClass: kSecClassGenericPassword as String,
            kSecAttrAccount: key,
            kSecValueData: data,
            /// Doc: You don’t need to set the accessible attribute directly if you set it as part of the access control attribute instead
            /// return errSecParam
//            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
        ] as [CFString: Any]
//        setAccess(to: &query)
        print("- delete status:", SecItemDelete(query as CFDictionary))
        //errSecItemNotFound
        // -25300
        
        let status = SecItemAdd(query as CFDictionary, nil)
        //errSecDuplicateItem
        //-25299
        print("- save(key status: \(status)")
        if status == errSecSuccess {
            
        } else {
            
        }
        return status
    }
    
//    enum Keys {
//        static let attrAccount = kSecAttrAccount as String
//    }
    
    func get(for key: String) -> Data? {
        
        var query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount : key,
            kSecReturnData : kCFBooleanTrue as Any,
            kSecMatchLimit : kSecMatchLimitOne,
            //kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
        ] as [CFString: Any]
        
//        setAccess(to: &query)
        
//        var dataTypeRef: AnyObject?
//        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        var result: AnyObject?
        
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        //errSecSuccess
        //noErr
        /// errSecSuccess == noErr
        
        if status == errSecSuccess {
            return result as? Data
        } else {
            print("- error object(for key \(status)")
            return nil
        }
    }
    
    /// not saving for simulator
    // TODO: test fo device
    private func setAccess(to query: inout [CFString: Any]) {
        
        /// https://developer.apple.com/documentation/security/keychain_services/keychain_items/restricting_keychain_item_accessibility
        var error: Unmanaged<CFError>?
        
        /// kCFAllocatorDefault == nil
        guard let access = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                           kSecAttrAccessibleWhenUnlocked,
                                                           SecAccessControlCreateFlags.biometryAny,
                                                           &error)
            else {
                assertionFailure()
                return
        }
        
        if let error = error?.takeRetainedValue() {
            debugPrint(error)
            assertionFailure(error.localizedDescription)
            return
        }
        query[kSecAttrAccessControl] = access
    }
    
    func allKeys() -> [String] {
        var query = [
            kSecClass : kSecClassGenericPassword,
            kSecReturnData : true,
            kSecReturnAttributes: true,
            kSecReturnRef: true,
            kSecMatchLimit: kSecMatchLimitAll
        ] as [CFString: Any]
        
//        setAccess(to: &query)
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
        var query: [CFString: Any] = [kSecClass : kSecClassGenericPassword ]
        //      query = addAccessGroupWhenPresent(query)
        //      query = addSynchronizableIfRequired(query, addingItems: false)
        //      lastQueryParameters = query
        setAccess(to: &query)
        
        let lastResultCode = SecItemDelete(query as CFDictionary)
        
        return lastResultCode == errSecSuccess || lastResultCode == errSecItemNotFound
    }
}
