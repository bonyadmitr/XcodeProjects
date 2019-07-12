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

/// https://medium.com/@dmytro.anokhin/concurrency-in-swift-reader-writer-lock-4f255ae73422
/**
 concurrentQueue.async(flags: .barrier)
 // .barrier flag ensures that within the queue all reading is done
 // before the below writing is performed and
 // pending readings start after below writing is performed
 https://medium.com/@oyalhi/dispatch-barriers-in-swift-3-6c4a295215d6
 
 Барьерная часть (flags: .barrier) означает, что замыкание не будет выполнено до тех пор, пока каждое замыкание в очереди не закончит свое выполнение. Другие замыкания будут размещены после барьерного и выполняться после того, как выполнится барьерное.
 
 Барьеры GCD делают одну интересную вещь — они ожидают момента, когда очередь будет полностью пуста, перед тем как выполнить свое замыкание Как только барьер начинает выполнять свое замыкание, он обеспечивает, чтобы очередь не выполняла никакие другие замыкания в течение этого времени и по существу работает как синхронная функция. Как только замыкание с барьером заканчивается, очередь возвращается к своей обычной работе, обеспечивая гарантию того, что никакая запись не будет проводиться одновременно с чтением или другой записью.
 
 SynchronizedArray
 //http://basememara.com/creating-thread-safe-arrays-in-swift/
 //https://gist.github.com/basememara/afaae5310a6a6b97bdcdbe4c2fdcd0c6
 */
final class SafeString {
    
    private let queue = DispatchQueue(label: "queue line \(#line)", attributes: .concurrent)
    
    private var str = String()
    
    var value: String {
        get {
            var tempString = String()
            queue.sync {
                tempString = str
            }
            return tempString
        }
        set {
            // Write with .barrier
            // This can be performed synchronously or asynchronously not to block calling thread.
            queue.async(flags: .barrier) {
                self.str = newValue
            }
        }
    }
}

/// https://github.com/BestKora/GCD-Swift3/blob/master/GCDPlayground.playground/Sources/Queues.swift
public class ThreadSafeString {
    private var internalString = ""
    let isolationQueue = DispatchQueue(label:"com.bestkora.isolation",
                                       attributes: .concurrent)
    
    public func addString(string: String) {
        isolationQueue.async(flags: .barrier) {
            self.internalString = self.internalString + string
        }
    }
    public func setString(string: String) {
        isolationQueue.async(flags: .barrier) {
            self.internalString = string
        }
    }
    
    public init (_ string: String){
        isolationQueue.async(flags: .barrier) {
            self.internalString = string
        }
    }
    
    public var text: String {
        var result = ""
        isolationQueue.sync {
            result = self.internalString
        }
        return result
    }
}

/// https://stackoverflow.com/a/42722478/5893286
final class AreaSelectionView: UIView {
    
    var startPoint: CGPoint!
    var shapeLayer: CAShapeLayer!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let point = touches.first?.location(in: self) else {
            assertionFailure()
            return
        }
        
        self.startPoint = point
        
        shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineDashPattern = [10,5]
        self.layer.addSublayer(shapeLayer)
        
        var dashAnimation = CABasicAnimation()
        dashAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        dashAnimation.duration = 0.75
        dashAnimation.fromValue = 0.0
        dashAnimation.toValue = 15.0
        dashAnimation.repeatCount = .infinity
        shapeLayer.add(dashAnimation, forKey: "linePhase")
        

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let point = touches.first?.location(in: self) else {
            assertionFailure()
            return
        }
        
        let path = CGMutablePath()
        path.move(to: self.startPoint)
        path.addLine(to: CGPoint(x: self.startPoint.x, y: point.y))
        path.addLine(to: point)
        path.addLine(to: CGPoint(x: point.x, y: self.startPoint.y))
        path.closeSubpath()
        self.shapeLayer.path = path
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.shapeLayer.removeFromSuperlayer()
        self.shapeLayer = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        self.shapeLayer.removeFromSuperlayer()
        self.shapeLayer = nil
    }
}

/// https://theswiftdev.com/2018/07/10/ultimate-grand-central-dispatch-tutorial-in-swift/
class ViewController: UIViewController {

//    lazy var label = UILabel {
//        $0.text = ""
//    }
    
    let queue = DispatchQueue(label: "queue line \(#line)", attributes: .concurrent)
    //let queue = DispatchQueue(label: "123", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    let semaphoreForQueue = DispatchSemaphore(value: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let areaSelectionView = AreaSelectionView()
        areaSelectionView.frame = view.frame
        areaSelectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(areaSelectionView)
        
        let safeString = SafeString()
//        let safeString = ThreadSafeString("")

        for i in 1...100 {
            DispatchQueue.global().async {
//            DispatchQueue.global().async {
                let strI = "\(i)"
                safeString.value = strI
                let q = safeString.value
                
//                safeString.setString(string: strI)
//                let q = safeString.text
                
                //safeString.value = strI
                //let q = safeString.value
                
                print(q)
                //assert(q == strI)
            }
        }
        
//
//        safeString.value = "1"
//        print("safeString: \(safeString.value)")
//        print("safeString: \(safeString.value)")
//        print("safeString: \(safeString.value)")
//        print("safeString: \(safeString.value)")
//        print("safeString: \(safeString.value)")
//        print("safeString: \(safeString.value)")
//        print("safeString: \(safeString.value)")
//        print("safeString: \(safeString.value)")
//        print("safeString: \(safeString.value)")
//        print("safeString: \(safeString.value)")
//
//        safeString.value = "2"
//        safeString.value = "2"
//        safeString.value = "2"
//        safeString.value = "2"
//        safeString.value = "2"
//        safeString.value = "2"
//        safeString.value = "2"
//        safeString.value = "2"
//        print("safeString: \(safeString.value)")
//        print("safeString: \(safeString.value)")
//        print("safeString: \(safeString.value)")
//        print("safeString: \(safeString.value)")
//        print("safeString: \(safeString.value)")
//        safeString.value = "3"
        
        
        
//        testDeadlockQueue()
//        testDeadlockMain1()
//        testDeadlockMain2()
        
//        testRaceCondition1()
//        testRaceCondition2()
        
//        q1()
        
//        groupBySemaphore()
//        groupByDispatchGroupWithQueueAsyncGroup()
//        groupByDispatchGroupDefault()
        
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
                self.semaphoreForQueue.wait()
                
                let q = DispatchOperation { item in
                    print("start", i)
                    
                    if item.isCanceled {
                        self.semaphoreForQueue.signal()
                        print("cancel-1", i)
                        return
                    }
                    
                    func delayCheckIsCanceled() {
                        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.3) {
                            if item.isCanceled {
                                print("checkIsCanceled", i)
                                self.semaphoreForQueue.signal()
                            } else {
                                delayCheckIsCanceled()
                            }
                        }
                    }
                    
                    delayCheckIsCanceled()
                    
                    DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                        if item.isCanceled {
                            print("cancel-2", i)
                            self.semaphoreForQueue.signal()
                            return
                        }
                        print("finish", i)
                        self.semaphoreForQueue.signal()
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
    
    // MARK: - Race condition
    /// solve by mutex
    
    func testRaceCondition1() {
        var count = 0
        let targetCount = 1000
        
        DispatchQueue.concurrentPerform(iterations: targetCount) { _ in
            count += 1
        }
        
        print("- count: \(count)")
        assert(count == targetCount)
    }
    
    func testRaceCondition2() {
        var count = 0
        let targetCount = 10000
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        
        for _ in 1...targetCount {
            group.enter()
            queue.async() {
                count += 1
                group.leave()
            }
        }
        
        group.wait()
        print("- count: \(count)")
        assert(count == targetCount)
    }
    
    // MARK: - anti-patterns
    
    func testDeadlockQueue() {
        let queue = DispatchQueue(label: "queue line \(#line)")
        //queue.sync {
        queue.async {
            
            /// Calling this function and targeting the current queue results in deadlock
            /// https://developer.apple.com/documentation/dispatch/dispatchqueue/1452870-sync
            queue.sync {
                /// this won't be executed -> deadlock!
                /// app will crash
            }
        }
    }
    
    func testDeadlockMain1() {
        /// Calling this function and targeting the current queue results in deadlock
        /// app will crash
        DispatchQueue.main.sync {}
    }
    
    func testDeadlockMain2() {
        /// What you are trying to do here is to launch the main thread synchronously from a background thread before it exits. This is a logical error.
        /// https://stackoverflow.com/questions/49258413/dispatchqueue-crashing-with-main-sync-in-swift?rq=1
        /// app will crash
        DispatchQueue.global().sync {
            DispatchQueue.main.sync {}
        }
    }
    
    // MARK: - groups
    
    func someLongTask(for i: Int) {
        print("\(i): Running async task...")
        sleep(UInt32.random(in: 1...3))
        //sleep(2)
        print("\(i): Async task completed")
    }

    /// https://theswiftdev.com/2018/07/10/ultimate-grand-central-dispatch-tutorial-in-swift/
    func groupBySemaphore() {
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global()
        let n = 9
        let range = 0..<n
        
        for i in range {
            queue.async {
                self.someLongTask(for: i)
                semaphore.signal()
            }
        }
        
        /// or #1
        range.forEach { _ in semaphore.wait() }
        
        /// or #2
        //for i in range {
        //    semaphore.wait()
        //    /// !!! NOTE: it will not be the same `i` as above
        //    print("completed \(i)")
        //}
        
        print("done")
    }
    
    func groupByDispatchGroupWithQueueAsyncGroup() {
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        let n = 9
        
        for i in 0..<n {
            queue.async(group: group) {
                self.someLongTask(for: i)
            }
        }
        group.wait()
        print("done")
    }
    
    func groupByDispatchGroupDefault() {
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        let n = 9
        
        for i in 0..<n {
            group.enter()
            queue.async {
                self.someLongTask(for: i)
                group.leave()
            }
        }
        group.wait()
        print("done")
    }
    
    // MARK: - tests Dispatch
    
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
    
    // MARK: - tests Benchmark
    
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
    
    // MARK: - tests ConcurrentInit
    
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
