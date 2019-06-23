//
//  ViewController.swift
//  GCD
//
//  Created by Bondar Yaroslav on 6/17/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class DispatchOperation {
    
    var item: DispatchWorkItem?
    
    func cancel() {
        item?.cancel()
//        item = nil
    }
    
    var isCanceled: Bool {
        return item?.isCancelled ?? true
    }
    
    init(block: @escaping (DispatchOperation) -> Void) {
        item = DispatchWorkItem(block: { [weak self] in
            guard let self = self else {
                return
            }
            block(self)
        })
    }
    
}

class ViewController: UIViewController {

    let queue = DispatchQueue(label: "123", attributes: .concurrent)
    //let queue = DispatchQueue(label: "123", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    let s = DispatchSemaphore(value: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        globalTestCountWhere()
        
//        q1()
        
        let q1 = testConcurrentInitDefault()
        let q2 = testConcurrentInitSeparate()
        print(q1 == q2)
//        print()
    }
    
    func testConcurrentInitDefault()  -> [Int] {
        var array = Array(repeating: 0, count: 1_000_000)
        
        let date1 = Date()
        DispatchQueue.concurrentPerform(iterations: array.count) { i in
            array[i] = i
        }
        print("finish date1", -date1.timeIntervalSinceNow)
        
        return array
    }
    
    func testConcurrentInitSeparate() -> [Int] {
        var array = Array(repeating: 0, count: 1_000_000)
        
        let N = array.count
        let n = 128
        
        let date1 = Date()
        DispatchQueue.concurrentPerform(iterations: array.count) { i in
            array[i] = i
        }
        
        DispatchQueue.concurrentPerform(iterations: N/n) { k in
            for i in (k * n)..<((k + 1) * n) {
                array[i] = i
            }
        }
        
        for i in (N - (N % n))..<N {
            array[i] = i
        }
        
        print("finish date1", -date1.timeIntervalSinceNow)
        
        return array
    }

    
    func q1() {
        
        DispatchQueue.global().async {
            
            for i in 1...100 {
                self.s.wait()
                
                let q = DispatchOperation { item in
                    print("start", i)
                    
                    if item.isCanceled {
                        self.s.signal()
                        print("cancel-1", i)
                        return
                    }
                    
                    DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                        if item.isCanceled {
                            print("cancel-2", i)
                            self.s.signal()
                            return
                        }
                        print("finish", i)
                        self.s.signal()
                    }
                    
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                        item.cancel()
                    }
                }
                
                
                
                
                self.queue.sync(execute: q.item!)
                //                DispatchQueue.global().sync(execute: q.item!)
                //                q.item?.perform()
                
                //            queue.async {
                //                self.s.wait()
                //                q.item!.perform()
                //            }
                
                //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                //                q.cancel()
                //            }
                
            }
            
            
            
        }
        
        
        
    }

}

