//
//  ViewController.swift
//  AlamofireTest
//
//  Created by Bondar Yaroslav on 5/3/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        SessionManager(
        
    }

    @IBAction private func send(_ sender: UIButton) {
//        let q = URL(string: "https://speed.hetzner.de/1GB.bin")!
//        URLSession.shared.dataTask(with: q) { (data, response, error) in
//            if let error = error as? URLError, error.code == .networkConnectionLost {
////                let responseError = CustomErrors.text(TextConstants.errorConnectedToNetwork)
////                fail?(.error(responseError))
//                return
//            }
//            print()
//        }.resume()
        
        let url = "https://speed.hetzner.de/1GB.bin"
        //let url = "https://www.google.com"
        request(url)
            .downloadProgress(closure: { progress in
                print("- pr", progress.fractionCompleted)
            })
            .responseString { response in
            print("-", response.error ?? "nil")
            print("-", response.response ?? "nil 2")
            print()
            //(response.error as! URLError).code == URLError.Code.networkConnectionLost
        }
    }

}

