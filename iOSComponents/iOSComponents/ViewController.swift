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

func roundAppCorners() {
    /// CHECK with animations
    /// but need it?
    /// https://www.google.by/search?newwindow=1&ei=o_SJWqLAKcrQwQKPlLC4Bg&q=swift+cornerRadius+for+window&oq=swift+cornerRadius+for+window&gs_l=psy-ab.3..33i21k1j33i160k1l2.7864.8591.0.8831.6.6.0.0.0.0.156.641.0j5.5.0....0...1c.1.64.psy-ab..1.5.639...0i22i30k1j0i22i10i30k1.0.8qssvCSHN-Y
    let window = UIApplication.shared.windows.last
    window?.clipsToBounds = true
    window?.layer.cornerRadius = 5
    window?.backgroundColor = UIColor.black
}
