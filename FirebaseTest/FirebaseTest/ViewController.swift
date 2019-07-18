//
//  ViewController.swift
//  FirebaseTest
//
//  Created by Yaroslav Bondar on 16/07/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import Crashlytics

/// To enable debug logging set the following application argument: -FIRAnalyticsDebugEnabled
/// https://help.apple.com/xcode/mac/8.0/#/dev3ec8a1cb4
///
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crashlyticsLogsLine()
        AnalyticsService.shared.log(event: "ViewController_viewDidLoad")
        addButton()
        recordError()
        
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        tabBarController?.viewControllers?.append(vc)
    }
    
    private func addButton() {
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    /// Creates a new issue that is grouped by NSSomeErrorDomain and -1001. Additional logged errors that use the same domain and code values will be grouped under this issue
    /// Data contained within the userInfo object are converted to key-value pairs and displayed in the keys/logs section within an individual issue
    /// Crashlytics only stores the most recent 8 exceptions in a given app session. If your app throws more than 8 exceptions in a session, older exceptions are lost
    private func recordError() {
        var someOptional: Int?
        someOptional = nil
        
        guard let someOptional2 = someOptional else {
            let userInfo: [String: Any] = [NSLocalizedDescriptionKey: "guard let unwrap",
                                           NSLocalizedFailureReasonErrorKey: "unwrap someOptional",
                                           NSLocalizedRecoverySuggestionErrorKey: "someOptional should not be nil",
                                           "SomeKey": -333,
                                           "SomeKey2": "-333s"]
            let error = NSError(domain: "NSSomeErrorDomain", code: -10001, userInfo: userInfo)
            Crashlytics.sharedInstance().recordError(error)
            //assertionFailure(error.localizedDescription)
            return
        }
        print(someOptional2)
    }
    
    @objc func crashButtonTapped(_ sender: AnyObject) {
        crashlyticsLogsLine()
        AnalyticsService.shared.log(event: "crashButtonTapped")
        
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        navigationController?.pushViewController(vc, animated: true)
        //Crashlytics.sharedInstance().crash()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        AnalyticsService.shared.setScreenName()
//    }
}
