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
        
        //keychainManager.accessGroup = ""
        
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

/// doc https://developer.apple.com/documentation/security/keychain_services/keychain_items/adding_a_password_to_the_keychain
final class KeychainManager {
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unhandledError(status: OSStatus)
    }
    
    /// possible error -34018. nees keychain sharing in capabilities
    var accessGroup: String?
    
    /**
     
    Specifies whether the items can be synchronized with other devices through iCloud. Setting this property to true will
     add the item to other devices with the `set` method and obtain synchronizable items with the `get` command. Deleting synchronizable items will remove them from all devices. In order for keychain synchronization to work the user must enable "Keychain" in iCloud settings.
     
    Does not work on macOS.
     
    */
    var isSynchronizable: Bool = false
    
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
        setAccessGroupIfNeed(to: &query)
        setSynchronizableIfNeed(to: &query, addingItems: true)
        
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
        setAccessGroupIfNeed(to: &query)
        setSynchronizableIfNeed(to: &query, addingItems: false)
        
//        var dataTypeRef: AnyObject?
//        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        var result: AnyObject?
        
        /// source https://stackoverflow.com/a/27721328/5893286
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
    
    private func setAccessGroupIfNeed(to query: inout [CFString: Any]) {
        guard let accessGroup = accessGroup else {
            return
        }
        query[kSecAttrAccessGroup] = accessGroup
    }
    
     /**
     Adds kSecAttrSynchronizable: kSecAttrSynchronizableAny` item to the dictionary when the `synchronizable` property is true.
      
      - parameter items: The dictionary where the kSecAttrSynchronizable items will be added when requested.
      - parameter addingItems: Use `true` when the dictionary will be used with `SecItemAdd` method (adding a keychain item). For getting and deleting items, use `false`.
      
      - returns: the dictionary with kSecAttrSynchronizable item added if it was requested. Otherwise, it returns the original dictionary.
     */
    func setSynchronizableIfNeed(to query: inout [CFString: Any], addingItems: Bool) {
        guard isSynchronizable else {
            return
        }
        query[kSecAttrSynchronizable] = (addingItems == true) ? true : kSecAttrSynchronizableAny
    }
    
    func allKeys() -> [String] {
        var query = [
            kSecClass : kSecClassGenericPassword,
            kSecReturnData : true,
            kSecReturnAttributes: true,
            kSecReturnRef: true,
            kSecMatchLimit: kSecMatchLimitAll
        ] as [CFString: Any]
        
        setAccessGroupIfNeed(to: &query)
        setSynchronizableIfNeed(to: &query, addingItems: false)
        
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
        setAccessGroupIfNeed(to: &query)
        setSynchronizableIfNeed(to: &query, addingItems: false)
//        setAccess(to: &query)
        
        let lastResultCode = SecItemDelete(query as CFDictionary)
        
        return lastResultCode == errSecSuccess || lastResultCode == errSecItemNotFound
    }
}
