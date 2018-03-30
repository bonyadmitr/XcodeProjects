//
//  BaseUITests.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 23/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation
import KIF

class BaseUITests: KIFTestCase {
    override func beforeAll() {
        super.beforeAll()
        //        useTestDatabase()
    }
    
    override func beforeEach() {
        super.beforeEach()
        //        backToRoot()
    }
}

extension BaseUITests {
    func tap(_ viewLabel: String) {
        tester().tapView(withAccessibilityLabel: viewLabel)
    }
    
    func expectToSeeAlert(_ message: String) {
        expectToSee(message)
    }
    
    func fillIn(_ accessibilityLabel: String, withText text: String) {
        tester().clearText(fromAndThenEnterText: text, intoViewWithAccessibilityLabel: accessibilityLabel)
    }
    
    func backToRoot() {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            navigationController.popToRootViewController(animated: false)
        }
    }
    
    func fillInUsername() {
        //        fillIn("Login - Username", withText: correctUsername)
    }
    
    func visitHomeScreen() {
        fillInUsername()
        fillInCorrectPassword()
        tap("Login")
    }
    
    func fillInCorrectPassword() {
        //        fillIn("Login - Password", withText: correctPassword)
    }
    
    
    func useTestDatabase() {
        //        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = name
    }
    
    func clearDatabase() {
        //        let realm = try! Realm()
        //        try! realm.write {
        //            realm.deleteAll()
        //        }
    }
    
    func expectToSee(_ text: String) {
        tester().waitForView(withAccessibilityLabel: text)
    }
    
}
