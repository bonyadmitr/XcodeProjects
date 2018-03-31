//
//  ViewController.swift
//  NotificationBanner
//
//  Created by zdaecqze zdaecq on 13.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

let banner = NotificationBanner()

class ViewController: UIViewController {
    
    
    var randomString: String {
        var str = ""
        for _ in 0..<random(20) {
            str += "a"
        }
        return str
    }
    func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    
    @IBAction func actionButton(sender: UIButton) {
        banner.show(title: randomString, message: randomString)
        banner.didPressBanner = {
            self.performSegueWithIdentifier("Show", sender: nil)
        }
    }
}

class ViewController2: UIViewController {
    
//    let banner = NotificationBanner()
    @IBAction func action(sender: AnyObject) {
        banner.show(title: "Some name", message: "any message")
        banner.didPressBanner = {}
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        banner.releaseMemory()
    }
}
