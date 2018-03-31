//
//  PasscodeStorage.swift
//  Passcode
//
//  Created by Bondar Yaroslav on 10/2/17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol PasscodeStorage {
    var isEmpty: Bool { get }
    func isEqual(to passcode: String) -> Bool
    func save(passcode: String)
    func clearPasscode()
    
    //        if !passcodeStorage.isEmpty {
    //            passcodeStorage.clearPasscode()
    //        }
}

class PasscodeStorageDefaults {
    static let passcodeKey = "passcodeKey"
    var passcode: String {
        get { return UserDefaults.standard.string(forKey: PasscodeStorageDefaults.passcodeKey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: PasscodeStorageDefaults.passcodeKey) }
    }
}
extension PasscodeStorageDefaults: PasscodeStorage {
    var isEmpty: Bool {
        return passcode.isEmpty
    }
    func isEqual(to passcode: String) -> Bool {
        return passcode == self.passcode
    }
    
    func save(passcode: String) {
        self.passcode = passcode
    }
    
    func clearPasscode() {
        passcode = ""
    }
}
