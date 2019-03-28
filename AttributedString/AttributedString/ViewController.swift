//
//  ViewController.swift
//  AttributedString
//
//  Created by Bondar Yaroslav on 3/27/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    let semaphore = DispatchSemaphore(value: 1000)
    let queue = DispatchQueue(label: UUID().uuidString, qos: .background, attributes: .concurrent)
//    let queue = DispatchQueue.global()
    
    var queues = [DispatchQueue]()
    var items = [DispatchWorkItem]()
    
    @IBAction private func someButton(_ sender: UIBarButtonItem) {
//        DispatchQueue.main.async {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
//        UIApplication.shared.applicationIconBadgeNumber = 10
//        sleep(1)
        
        DispatchQueue.global().async {
            //        q1()
            self.q2()
            self.mainStart()
        }
    }
    
    func q1() {
        for i in 1...1000 {
            let item = DispatchWorkItem {
                sleep(1)
                print(i)
            }
            
            items.append(item)
            
//            let localQueue = DispatchQueue(label: UUID().uuidString)
            let localQueue = DispatchQueue(label: UUID().uuidString, qos: .background, attributes: .concurrent)
            queues.append(localQueue)
            localQueue.async(execute: item)
        }
    }
    
    func q2() {
//        autoreleasepool {
            for i in 1...1000 {
                
                let item = DispatchWorkItem {
                    sleep(1)
                    print(i)
                }
                
                self.items.append(item)
                self.queue.async(execute: item)
            }
            
//        }
    }
    
    func mainStart() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("--- cancel all")
            self.items.forEach({ $0.cancel() })
            self.items.removeAll()
            
            self.queues.removeAll()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
    }


}

