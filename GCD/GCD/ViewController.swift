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

extension Collection {
    func countLoop(where completion: (Element) -> Bool) -> Int {
        var count = 0
        for element in self where completion(element) {
            count += 1
        }
        return count
    }
    
    func countFilter(where predicate: (Element) -> Bool) -> Int {
        return filter(predicate).count
    }
}

extension Array {
    func countConcurrent(where predicate: (Element) -> Bool) -> Int {
        var count = 0
        
        /// https://habr.com/ru/company/nixsolutions/blog/336260/
        /// https://github.com/mattgallagher/CwlUtils/blob/master/Sources/CwlUtils/CwlMutex.swift
        var underlyingMutex = os_unfair_lock()
        
        DispatchQueue.concurrentPerform(iterations: self.count) { i in
            if predicate(self[i]) {
                os_unfair_lock_lock(&underlyingMutex)
                count += 1
                os_unfair_lock_unlock(&underlyingMutex)
            }
        }
        return count
    }
}

class ViewController: UIViewController {

    let queue = DispatchQueue(label: "123", attributes: .concurrent)
    //let queue = DispatchQueue(label: "123", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    let s = DispatchSemaphore(value: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        test()
//        q1()
        
//        let q1 = testInit1()
//        let q2 = testInit2()
//        print(q1 == q2)
//        print()
    }
    
    func test() {
        var array = Array(repeating: 0, count: 10_000_000)
        
        DispatchQueue.concurrentPerform(iterations: array.count) { i in
            array[i] = i
        }
        
        print("start")
        
        let date1 = Date()
        let count1 = array.countLoop(where: { $0 > 50_000 })
        print("finish countLoop", count1, -date1.timeIntervalSinceNow)
        
        let date2 = Date()
        let count2 = array.countFilter(where: { $0 > 50_000 })
        print("finish countConcurrent", count2, -date2.timeIntervalSinceNow)
        
        let date3 = Date()
        let count3 = array.countConcurrent(where: { $0 > 50_000 })
        print("finish countConcurrent", count3, -date3.timeIntervalSinceNow)
    }
    
    func testInit1()  -> [Int] {
        var array1 = Array<Int>.init(repeating: 0, count: 100_000_000)
        
        let date1 = Date()
        DispatchQueue.concurrentPerform(iterations: array1.count) { i in
            array1[i] = i
        }
        print("finish date1", -date1.timeIntervalSinceNow)
        
        return array1
    }
    
    func testInit2() -> [Int] {
        var array1 = Array<Int>.init(repeating: 0, count: 100_000_000)
        
        let N = array1.count
        let n = 128
        
        let date1 = Date()
        DispatchQueue.concurrentPerform(iterations: array1.count) { i in
            array1[i] = i
        }
        
        DispatchQueue.concurrentPerform(iterations: N/n) { k in
            for i in (k * n)..<((k + 1) * n) {
                array1[i] = i
            }
        }
        
        for i in (N - (N % n))..<N {
            array1[i] = i
        }
        
        print("finish date1", -date1.timeIntervalSinceNow)
        
        return array1
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

