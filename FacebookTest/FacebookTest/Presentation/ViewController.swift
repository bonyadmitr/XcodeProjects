//
//  ViewController.swift
//  FacebookTest
//
//  Created by Bondar Yaroslav on 04/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import FacebookShare

class ViewController: UIViewController {

    @IBAction func actionLoginButton(_ sender: UIButton) {
        _ = FacebookManager.shared.loginForPublishActions()
    }
    
    @IBAction func actionShareButton(_ sender: UIButton) {
        let content = LinkShareContent(url: URL(string: "https://developers.facebook.com")!)
        _ = try? ShareDialog.show(from: self, content: content)
    }
}

