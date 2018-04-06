//
//  ViewController.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// localizedDescription: "The requested operation couldn’t be completed because the feature is not supported."
/// localized. example ru: "Операцию не удалось завершить, так как эта функция не поддерживается."
let unknownError = NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo: [:])

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = ClosureTapGesture { [unowned self] gesture in
            print("tap gesture", gesture.location(in: self.view))
        }
        view.addGestureRecognizer(tapGesture)
        
        
        Result.success(())
        let q = Result<Void>.failure(unknownError).error?.localizedDescription
        print(q)
    }
}

//    lazy var vc2: ViewController2 = {
//        return self.childViewControllers.first(of: ViewController2.self)!
//    }()
//Array+Extensions
extension Array {
    public func first<T>(of type: T.Type) -> T? {
        return first { $0 is T } as? T
    }
}

