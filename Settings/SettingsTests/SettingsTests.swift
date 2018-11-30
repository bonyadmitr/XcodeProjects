//
//  SettingsTests.swift
//  SettingsTests
//
//  Created by Bondar Yaroslav on 11/10/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import XCTest
@testable import Settings

class SettingsTests: XCTestCase {
    
    let vc = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!
    
    override func setUp() {
        vc.dismiss(animated: false, completion: nil)
        super.setUp()
        
        RateCounter(untilPromptDays: 1,
                    launches: 1,
                    significantEvents: 1,
                    foregroundAppears: 1).resetLaunchesEventsAndForegroundAppears()
    }
    
    override func tearDown() {

        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    private var rateAppDisplayManager: RateAppDisplayManager?
//    let vc = UIViewController()
    
    func testRateAppDisplayManagerIsDebug() {
//        let vc = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!
        rateAppDisplayManager = RateAppDisplayManager(untilPromptDays: 1,
                                                      launches: 1,
                                                      significantEvents: 1,
                                                      foregroundAppears: 1)
        rateAppDisplayManager?.isDebug = true
        rateAppDisplayManager?.startObserving(presentIn: vc)
        
        let expec = expectation(description: "1")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expec.fulfill()
        }
        
        waitForExpectations(timeout: 4, handler: nil)
        
        //XCTAssertNotNil(vc.presentationController)
        XCTAssert(vc.presentedViewController != nil)
    }
    
    func testRateAppDisplayManagerForegroundAppears1() {
//        let vc = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!
        rateAppDisplayManager = RateAppDisplayManager(untilPromptDays: 0,
                                                      launches: 0,
                                                      significantEvents: 0,
                                                      foregroundAppears: 4)
        rateAppDisplayManager?.startObserving(presentIn: vc)
        
        if vc.presentedViewController == nil {
            NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
            NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
        } else {
            vc.dismiss(animated: false, completion: {
                /// UIApplicationWillEnterForeground func will be called bcz we have two objects of RateAppDisplayManager (main app + test)
                NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
                NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
            })
        }

        
        let expec = expectation(description: "1")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expec.fulfill()
        }
        
        waitForExpectations(timeout: 4, handler: nil)
        
        //XCTAssertNotNil(vc.presentationController)
        XCTAssert(vc.presentedViewController != nil)
    }
    
    func testRateAppDisplayManagerForegroundAppears2() {
//        let vc = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!
        rateAppDisplayManager = RateAppDisplayManager(untilPromptDays: 0,
                                                      launches: 0,
                                                      significantEvents: 0,
                                                      foregroundAppears: 5)
        rateAppDisplayManager?.startObserving(presentIn: vc)
        
//        NotificationCenter.default.post(name: .UIApplicationWillEnterForeground, object: UIApplication.shared)
//        NotificationCenter.default.post(name: .UIApplicationWillEnterForeground, object: UIApplication.shared)
        
//        vc.dismiss(animated: false, completion: {
//            /// UIApplicationWillEnterForeground func will be called bcz we have two objects of RateAppDisplayManager (main app + test)
//            NotificationCenter.default.post(name: .UIApplicationWillEnterForeground, object: UIApplication.shared)
//            NotificationCenter.default.post(name: .UIApplicationWillEnterForeground, object: UIApplication.shared)
//        })
        
        if vc.presentedViewController == nil {
            NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
            NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
        } else {
            vc.dismiss(animated: false, completion: {
                /// UIApplicationWillEnterForeground func will be called bcz we have two objects of RateAppDisplayManager (main app + test)
                NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
                NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
            })
        }
        
        
        let expec = expectation(description: "1")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expec.fulfill()
        }
        
        waitForExpectations(timeout: 4, handler: nil)
        
        //XCTAssertNotNil(vc.presentationController)
        XCTAssert(vc.presentedViewController == nil)
    }
    
    func testRateAppDisplayManagerSignificantEvents1() {
//        let vc = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!
        rateAppDisplayManager = RateAppDisplayManager(untilPromptDays: 0,
                                                      launches: 0,
                                                      significantEvents: 3,
                                                      foregroundAppears: 0)
        rateAppDisplayManager?.startObserving(presentIn: vc)
        
        rateAppDisplayManager?.rateCounter.incrementEventsCount()
        rateAppDisplayManager?.rateCounter.incrementEventsCount()
        rateAppDisplayManager?.rateCounter.incrementEventsCount()
        
        let expec = expectation(description: "1")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expec.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        //XCTAssertNotNil(vc.presentationController)
        XCTAssert(vc.presentedViewController != nil)
    }
    
    func testRateAppDisplayManagerSignificantEvents2() {
        //        let vc = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!
        rateAppDisplayManager = RateAppDisplayManager(untilPromptDays: 0,
                                                      launches: 0,
                                                      significantEvents: 3,
                                                      foregroundAppears: 0)
        rateAppDisplayManager?.startObserving(presentIn: vc)
        
        rateAppDisplayManager?.rateCounter.incrementEventsCount()
        rateAppDisplayManager?.rateCounter.incrementEventsCount()
        
        let expec = expectation(description: "1")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expec.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        //XCTAssertNotNil(vc.presentationController)
        XCTAssert(vc.presentedViewController == nil)
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}


class SettingsStorageTests: XCTestCase {
    
    private let suiteName = "test"
    
    override func tearDown() {
        
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        let userDefaults = UserDefaults(suiteName: suiteName)!
        var settingsStorage: SettingsStorage = SettingsStorageImp(userDefaults: userDefaults)
        
        /// check default value
        XCTAssert(settingsStorage.isEnabledVibration == false)
    }
    
    func testSave() {
        let userDefaults = UserDefaults(suiteName: suiteName)!
        var settingsStorage: SettingsStorage = SettingsStorageImp(userDefaults: userDefaults)
        settingsStorage.isEnabledVibration = false
        XCTAssert(settingsStorage.isEnabledVibration == false)
    }
    
    func testResetToDefault() {
        let userDefaults = UserDefaults(suiteName: suiteName)!
        var settingsStorage: SettingsStorage = SettingsStorageImp(userDefaults: userDefaults)
        settingsStorage.isEnabledVibration = false
        settingsStorage.resetToDefault()
        
        /// check default value
        XCTAssert(settingsStorage.isEnabledVibration == false)
    }
}
