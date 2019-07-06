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

class ViewController: UIViewController {

//    lazy var label = UILabel {
//        $0.text = ""
//    }
    
    let queue = DispatchQueue(label: "123", attributes: .concurrent)
    //let queue = DispatchQueue(label: "123", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    let s = DispatchSemaphore(value: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        q1()
        
//        testBenchmarkDateFormatter()
//        testBenchmarkCountWhere()

//        testDispatchAssert()
        
//        globalTestCountWhere()
        
//        let array1 = testConcurrentInitDefault()
//        let array2 = testConcurrentInitSeparate()
//        let array3 = testInitDefault()
//        print(array1 == array2)
//        print(array1 == array3)
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
                    
                    func delayCheckIsCanceled() {
                        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
                            if item.isCanceled {
                                print("checkIsCanceled", i)
                                self.s.signal()
                            } else {
                                delayCheckIsCanceled()
                            }
                        }
                    }
                    
                    delayCheckIsCanceled()
                    
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

    
    private func testDispatchSpecificKey() {
        /// Different instances of DispatchSpecificKey share the same pointer
        /// http://tom.lokhorst.eu/2018/02/leaky-abstractions-in-swift-with-dispatchqueue
        while true {
            let key = DispatchSpecificKey<Int>()
            let p = Unmanaged.passUnretained(key).toOpaque()
            print("Address: \(p)")
            
            if let value = DispatchQueue.main.getSpecific(key: key) {
                print("Error, already set value: \(value)")
                exit(1)
            } else {
                DispatchQueue.main.setSpecific(key: key, value: 42)
                print("OK")
                sleep(1)
            }
            
            /// fix
            DispatchQueue.main.setSpecific(key: key, value: nil)
        }
    }
    
    func testDispatchAssert() {
        //dispatchPrecondition(condition: .onQueue(.main))
        dispatchAssert(condition: .onQueue(.main))
        assertMainQueue()
        
        DispatchQueue.global().async {
            assertBackgroundQueue()
        }
        
        /// can be used for iOS 9
        DispatchQueue.setupMainQueue()
        assert(DispatchQueue.isMainQueue)
        
        let customQueue = DispatchQueue(label: "label")
        
        #if DEBUG
        let dispatchKey = DispatchSpecificKey<Void>()
        customQueue.setSpecific(key: dispatchKey, value: ())
        #endif
        
        customQueue.async {
            #if DEBUG
            let isCustomQueue = DispatchQueue.getSpecific(key: dispatchKey) != nil
            assert(isCustomQueue)
            #endif
        }
    }
    
    func testBenchmarkDateFormatter() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let benchmark1 = Benchmark.average(iterations: 1000) {
            _ = dateFormatter.string(from: Date())
        }
        print(benchmark1.average)
        
        print()
        
        let benchmark2 = Benchmark.average(iterations: 1000) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
            _ = dateFormatter.string(from: Date())
        }
        print(benchmark2.average)
        
        print(
            benchmark1.average > benchmark2.average
        )
    }
    
    func testBenchmarkCountWhere() {
        var array = Array(repeating: 0, count: 1_000_000)
        
        DispatchQueue.concurrentPerform(iterations: array.count) { i in
            array[i] = i
        }
        
        print(
            "Benchmark countLoop:\n",
            Benchmark.average {
                _ = array.countLoop(where: { $0 > 50_000 })
            }.average
        )
        
        print(
            "Benchmark countConcurrent:\n",
            Benchmark.average {
                _ = array.countConcurrent(where: { $0 > 50_000 })
            }.average
        )
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
    
    func testInitDefault()  -> [Int] {
        let n = 1_000_000
        var array = Array(repeating: 0, count: n)
        
        let date = Date()
        for i in 0..<n {
            array[i] = i
        }
        print("finish", -date.timeIntervalSinceNow)
        
        return array
    }
}
