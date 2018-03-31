//
//  ViewController.swift
//  MainThreadGuard
//
//  Created by Bondar Yaroslav on 15/05/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var someView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    @IBAction func actionMainButton(_ sender: UIButton) {
        someView.backgroundColor = UIColor.red
    }
    
    @IBAction func actionBackgroundButton(_ sender: UIButton) {
        let barrier = DispatchQueue(label: "org.promisekit.barrier123", attributes: .concurrent)
        barrier.async {
            print(Thread.isMainThread)
            self.someView.backgroundColor = UIColor.blue
        }
//        DispatchQueue.global(qos: .background).async {
//            self.someView.backgroundColor = UIColor.blue
//        }
    }
}

