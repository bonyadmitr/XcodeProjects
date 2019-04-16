//
//  ViewController.swift
//  TodayExtensionTest
//
//  Created by Bondar Yaroslav on 09/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var someLabel: UILabel!
    @IBOutlet weak var someTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDeviceUnlockedObserver()
        addDeviceLockedObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        someLabel.text = String(SharedUserDefaults.shared.shownCounter)
    }

    
    @IBAction func changedSomeTextField(_ sender: UITextField) {
        SharedUserDefaults.shared.someText = sender.text
    }
    
    
    /// https://gist.github.com/immortalsantee/1e0832c2ada68a2c8893ce9a0b8a1467
    weak var deviceUnlockedObserver: NSObjectProtocol?
    weak var deviceLockedObserver: NSObjectProtocol?
    var isDeviceLocked = true {
        didSet {
            print("- isDeviceLocked", isDeviceLocked)
        }
    }
    
    private func addDeviceUnlockedObserver() {
        guard deviceUnlockedObserver == nil else {return}
        
        deviceUnlockedObserver = NotificationCenter.default.addObserver(forName: UIApplication.protectedDataDidBecomeAvailableNotification, object: nil, queue: nil) { (noti) in
            /// main queue by defalut
            self.isDeviceLocked = false
        }
    }
    
    private func addDeviceLockedObserver() {
        guard deviceLockedObserver == nil else {return}
        
        deviceLockedObserver = NotificationCenter.default.addObserver(forName: UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil, queue: nil) { (noti) in
            self.isDeviceLocked = true
        }
    }
    
    private func removeObserver() {
        if let unlockObserver = deviceUnlockedObserver {
            NotificationCenter.default.removeObserver(unlockObserver)
        }
        if let lockedObserver = deviceLockedObserver {
            NotificationCenter.default.removeObserver(lockedObserver)
        }
    }

}
