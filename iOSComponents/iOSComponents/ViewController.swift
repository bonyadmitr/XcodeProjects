//
//  ViewController.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

public typealias VoidHandler = () -> Void

/// localizedDescription: "The requested operation couldn’t be completed because the feature is not supported."
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
