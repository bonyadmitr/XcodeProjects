//
//  ViewController.swift
//  UnitTestsAndPerformance
//
//  Created by Yaroslav Bondar on 23/07/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var handler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .red
        
        handler = { [weak self] in
            guard let self = self else {
                return
            }
            print("- handler", self)
        }
        
        //handler = someFunc
        
        handler?()
    }
    
    func someFunc() {
        print("- handler", self)
    }
}

func assertDeallocation(_ testedViewController: @escaping () -> UIViewController) {
    #if DEBUG
    
//    let rootViewController = UIViewController()
    
    
    
    // Make sure that the view is active and we can use it for presenting views.
//    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
//    let window = UIWindow()
    let window = UIApplication.shared.delegate!.window!!
    let rootViewController = window.rootViewController!
//    window.rootViewController = rootViewController
//    window.makeKeyAndVisible()
    
    DispatchQueue.global().async {
        weak var weakReferenceViewController: UIViewController?
        let autoreleasepoolSemaphore = DispatchSemaphore(value: 0)
        
        autoreleasepool {
            
            DispatchQueue.main.async {
                /// Present and dismiss the view after which the view controller should be released.
                rootViewController.present(testedViewController(), animated: false, completion: {
                    weakReferenceViewController = rootViewController.presentedViewController
                    assert(weakReferenceViewController != nil)
                    
                    rootViewController.dismiss(animated: false, completion: {
                        autoreleasepoolSemaphore.signal()
                    })
                })
            }

        }
        
        let result = autoreleasepoolSemaphore.wait(timeout: .now() + 5)
        print("-", weakReferenceViewController ?? "nil1")
        
        switch result {
        case .success:
            assert(weakReferenceViewController == nil)
        case .timedOut:
            assertionFailure()
        }
        
        print("1")
        print("-", weakReferenceViewController ?? "nil1")
    }

    #endif
}
