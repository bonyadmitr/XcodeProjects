//
//  ViewController.swift
//  DropboxSdk
//
//  Created by Bondar Yaroslav on 4/4/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var show = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if show {
            return
        }
        show = true
        
        DropboxManager.shared.loginIfNeed { result in
            switch result {
            case .success(let token):
                print(token)
            case .failed(let text):
                print(text)
            case .cancel:
                print("cancel")
            }
        }
    }
}
