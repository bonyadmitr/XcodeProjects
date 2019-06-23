//
//  ViewController.swift
//  GCD
//
//  Created by Bondar Yaroslav on 6/17/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

import Foundation

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

/// https://developer.apple.com/swift/blog/?id=4
@available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
func dispatchAssert(condition: @autoclosure () -> DispatchPredicate) {
    //if #available(iOS 10.0, *) {}
    #if DEBUG
    dispatchPrecondition(condition: condition())
    #endif
}

@available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
func assertMainQueue() {
    dispatchAssert(condition: .onQueue(.main))
}

@available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
func assertBackgroundQueue() {
    dispatchAssert(condition: .notOnQueue(.main))
}


class ViewController: UIViewController {

    let queue = DispatchQueue(label: "123", attributes: .concurrent)
    //let queue = DispatchQueue(label: "123", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    let s = DispatchSemaphore(value: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        globalTestCountWhere()
        
//        q1()
        
//        let dispatchKey = DispatchSpecificKey<Void>()
//        DispatchQueue.main.setSpecific(key: dispatchKey, value: ())
//
//        if DispatchQueue.getSpecific(key: dispatchKey) == nil {
//
//        }
        
//        dispatchPrecondition(condition: .onQueue(.main))
        dispatchAssert(condition: .onQueue(.main))
        assertMainQueue()
        
        DispatchQueue.global().async {
            assertBackgroundQueue()
        }
        
        let array1 = testConcurrentInitDefault()
        let array2 = testConcurrentInitSeparate()
        print(array1 == array2)
    }
    
    func testConcurrentInitDefault()  -> [Int] {
        var array = Array(repeating: 0, count: 1_000_000)
        
        let date = Date()
        DispatchQueue.concurrentPerform(iterations: array.count) { i in
            array[i] = i
        }
        print("finish", -date.timeIntervalSinceNow)
        
        return array
    }
    
    /// https://stackoverflow.com/q/41215048/5893286
    func testConcurrentInitSeparate() -> [Int] {
        var array = Array(repeating: 0, count: 1_000_000)
        
        let N = array.count
        let n = 128
        
        let date = Date()
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
        
        print("finish", -date.timeIntervalSinceNow)
        
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

