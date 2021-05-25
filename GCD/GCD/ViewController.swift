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

// general + Dispatch Sources https://khanlou.com/2016/04/the-GCD-handbook/

// TODO: attributes: .initiallyInactive
// TODO: autoreleaseFrequency: .inherit
//let queue = DispatchQueue(label: "lessAggressiveQueue", attributes: .initiallyInactive, autoreleaseFrequency: .inherit, target: .global())
//queue.activate()


// TODO: test
// google swift overcommit queue
/// setting a target queue on serial queues is generally a good idea, specifically to turn off overcommit
/// https://twitter.com/Catfish_Man/status/1369796012135485440
/// source https://mjtsai.com/blog/2021/03/16/underused-and-overused-gcd-patterns/
//let lessAggressiveQueue = DispatchQueue(label: "lessAggressiveQueue", attributes: .initiallyInactive, autoreleaseFrequency: .inherit, target: .global())



/// ReadWriteLock vs queue https://medium.com/@dmytro.anokhin/concurrency-in-swift-reader-writer-lock-4f255ae73422
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

struct Student {
    let name: String
    let passportNumber: String
}
// #1
extension Student: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.passportNumber == rhs.passportNumber
    }
}
// #2
//func == (lhs: Student, rhs: Student) -> Bool {
//    return lhs.passportNumber == rhs.passportNumber
//}
///let isSame = Student(name: "1", passportNumber: "1") == Student(name: "2", passportNumber: "2")

/// https://theswiftdev.com/2018/07/10/ultimate-grand-central-dispatch-tutorial-in-swift/
class ViewController: UIViewController {

//    lazy var label = UILabel {
//        $0.text = ""
//    }
    
    let queue = DispatchQueue(label: "___concurrent line \(#line)", attributes: .concurrent)
    //let queue = DispatchQueue(label: "123", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    let semaphoreForQueue = DispatchSemaphore(value: 3)
    let queue2 = DispatchQueue(label: "___serial line \(#line)", target: .global())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        //queue2.activate()
        queue2.async {
            print("isMainThread: \(Thread.isMainThread)")
        }
        
        /// same `sleep(1)`
        
//        for i in 1...100 {
//            queue.async {
//                Thread.sleep(forTimeInterval: 1)
//                print("Task \(i)")
//            }
//        }
        let semaphore = DispatchSemaphore(value: 3)
        for i in 1...10 {
            queue.async {
                Thread.sleep(forTimeInterval: 1)
                print("Task \(i)")
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        queue.async(flags: .barrier) {
            print("done")
            print()
            
            self.queue2.async {
                print("done 2")
            }
        }

        
//        let safeString = SafeString()
////        let safeString = ThreadSafeString("")
//
//        for i in 1...100 {
//            DispatchQueue.global().async {
////            DispatchQueue.global().async {
//                let strI = "\(i)"
//                safeString.value = strI
//                let q = safeString.value
//
////                safeString.setString(string: strI)
////                let q = safeString.text
//
//                //safeString.value = strI
//                //let q = safeString.value
//
//                print(q)
//                //assert(q == strI)
//            }
//        }
        
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
//        testDeadlockQueue4()
        
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
    // MARK: - tasks
    
    private let tasks = [
        ("1", 3),
        ("2", 1),
        ("3", 1),
        ("4", 2),
        ("5", 2),
    ]
    private func perform(_ task: (String, Int), handler: @escaping (String) -> Void) {
        DispatchQueue.global().async {
            print("- started task: \(task.0)")
            sleep(UInt32(task.1))
            print("- ended task: \(task.0)")
            handler(task.0)
        }
    }
    
    
    // TODO: problem in lock free `res += taskTitle`
    // TODO: assert(res.count == tasks.count)
    
    /// Dispatch Barrier Block Dispatch barrier blocks create a serial-style bottleneck when working with concurrent queues
    /// thread safe
    private static let safeWriteQueue = DispatchQueue(label: "safeWriteQueue", attributes: .concurrent)
    private static func safeWrite(handler: @escaping () -> Void) {
        safeWriteQueue.async(flags: .barrier, execute: handler)
    }
    
    // TODO: todo tasks:
    // task 1: any order, any number of threads
    // task 2: same order, one thread (1 by 1)
    // task 3: any order, constant number of threads
    // task 4: same order, any number of threads
    // task 5: same order, constant number of threads
    func taskInitial() {
        var res = ""
        
        for task in tasks {
            
            perform(task) { taskTitle in
                res += taskTitle
            }
        }
        
        print("\(#function) result: \(res)")
    }
    
    // task 1: any order, any number of threads
    func task1() {
        var res = ""
        let group = DispatchGroup()
        
        for task in tasks {
            
            group.enter()
            perform(task) { taskTitle in
                Self.safeWrite {
                    res += taskTitle
                    group.leave()
                }
                
            }
            
        }
        
        group.wait()
        print("\(#function) result: \(res)")
    }
    
    // task 2: same order, one thread (1 by 1)
    func task2() {
        var res = ""
        let semaphore = DispatchSemaphore(value: 0)
        
        for task in tasks {
            
            perform(task) { taskTitle in
                res += taskTitle
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        print("\(#function) result: \(res)")
    }
    
    // task 3: any order, constant number of threads
    func task3() {
        
        var res = ""
        let threadsMaxCount = 3
        let semaphore = DispatchSemaphore(value: threadsMaxCount)
        
        for task in tasks {
            semaphore.wait()
            
            perform(task) { taskTitle in
                res += taskTitle
                semaphore.signal()
            }
        }
        
        (1...threadsMaxCount).forEach { _ in semaphore.wait() }
        (1...threadsMaxCount).forEach { _ in semaphore.signal() }
        
        print("\(#function) result: \(res)")
        
    }
    
    
    
    // MARK: - others
    
    func groupUrls() {
        let urls = [URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/1.jpg")!,
                    URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/2.jpg")!,
                    URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/3.jpg")!,
                    URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/4.jpg")!,
                    URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/5.jpg")!]
        
        var imagesData = [Data]()
        let group = DispatchGroup()

        for url in urls {
            group.enter()
            
            DispatchQueue.global().async {
                print("started \(url.lastPathComponent)")
                if let data = try? Data(contentsOf: url) {
                    imagesData.append(data)
                    print("downloaded \(url.lastPathComponent)")
                }
                group.leave()
            }
            
        }

        group.wait()
        print("\(imagesData.count) images downloaded. Is main thread? \(Thread.isMainThread)")
        
//        group.notify(queue: .main) {
//            print("\(imagesData.count) images downloaded. Is main thread? \(Thread.isMainThread)")
//        }
        
    }
    
    func semaphoreUrls() {
        let urls = [URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/1.jpg")!,
                    URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/2.jpg")!,
                    URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/3.jpg")!,
                    URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/4.jpg")!,
                    URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/5.jpg")!]
        
        var imagesData = [Data]()
        let semaphore = DispatchSemaphore(value: 0)

        for url in urls {
            
            DispatchQueue.global().async {
                print("started \(url.lastPathComponent)")
                if let data = try? Data(contentsOf: url) {
                    imagesData.append(data)
                    print("downloaded \(url.lastPathComponent)")
                }
                semaphore.signal()
            }
            semaphore.wait()
        }

        print("\(imagesData.count) images downloaded. Is main thread? \(Thread.isMainThread)")
        
    }
    
    func semaphoreThreadsUrls() {
        let urls = (1...5).compactMap { URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/\($0).jpg") }
        
//        let urls = ["1.jpg", "2.jpg", "3.jpg", "4.jpg", "5.jpg"]
//            .compactMap { URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/\($0)") }
        
//        let urls = [
//            "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/1.jpg",
//            "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/2.jpg",
//            "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/3.jpg",
//            "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/4.jpg",
//            "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/5.jpg",
//        ].compactMap { URL(string: $0) }
        
//        let urls = [URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/1.jpg")!,
//                    URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/2.jpg")!,
//                    URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/3.jpg")!,
//                    URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/4.jpg")!,
//                    URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/5.jpg")!]
        
        var imagesData = [Data]()
        let threadsMaxCount = 3
        let semaphore = DispatchSemaphore(value: threadsMaxCount)
        
        for url in urls {
            semaphore.wait()
            DispatchQueue.global().async {
                print("started \(url.lastPathComponent)")
                if let data = try? Data(contentsOf: url) {
                    imagesData.append(data)
                    print("downloaded \(url.lastPathComponent)")
                }
                semaphore.signal()
            }
            
        }
        (1...threadsMaxCount).forEach { _ in semaphore.wait() }
        (1...threadsMaxCount).forEach { _ in semaphore.signal() }

        print("\(imagesData.count) images downloaded. Is main thread? \(Thread.isMainThread)")
        
    }
    
func urlsInitial() {
    let urls = (1...5).compactMap { URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/\($0).jpg") }
    var imagesData = [Data]()
    
    for url in urls {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                imagesData.append(data)
            }
        }
        
    }
    
    assert(imagesData.count == urls.count)
    assert(Thread.isMainThread == true)
    print("\(imagesData.count) images downloaded. Is main thread? \(Thread.isMainThread)")
}
/// DispatchGroup answer
//func urlsInitial() {
//    let urls = (1...5).compactMap { URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/\($0).jpg") }
//    var imagesData = [Data]()
//    let group = DispatchGroup()
//
//    for url in urls {
//        group.enter()
//        DispatchQueue.global().async {
//            if let data = try? Data(contentsOf: url) {
//                imagesData.append(data)
//            }
//            group.leave()
//        }
//    }
//
//    group.wait()
//    assert(imagesData.count == urls.count)
//    assert(Thread.isMainThread == true)
//    print("\(imagesData.count) images downloaded. Is main thread? \(Thread.isMainThread)")
//}
    
    
    
    
    func semaphore1() {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global(qos: .background).async {
            
            for i in 1...20 {
                print("start", i)
                self.longBackgroundTask(i: i) {
                    semaphore.signal()
                }
                semaphore.wait()
                print("end", i)
            }
            
            print("--- done all")
        }
        
    }
    
    
    
    func semaphore2() {
        /// https://medium.com/@roykronenfeld/semaphores-in-swift-e296ea80f860
        let queue = DispatchQueue(label: "com.gcd.myQueue", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 3)
        for songNumber in 1 ... 15 {
           queue.async {
              semaphore.wait()
              print("Downloading song", songNumber)
              sleep(2) // Download take ~2 sec each
              print("Downloaded song", songNumber)
              semaphore.signal()
           }
        }
        print("--- done all")
    }
    
    private func longBackgroundTask(i: Int, handler: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            print("work", i)
            handler()
        }
    }
    
    func semaphoreForQueue1() {
        
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
    
    /// https://github.com/AgranatMarkit/YouCanHaveFunWithConcurrentQueue
    func testDeadlockQueue4() {
        let queue = DispatchQueue(label: "queue line \(#line)", attributes: .concurrent)
        for i in 1...10000 {
            queue.async {
                
                for j in 1...10 {
                    queue.sync {
                        print("\(i)-\(j)")
                    }
                }

            }
        }

        /// this won't be executed
        queue.asyncAfter(deadline: .now() + 3) {
            print("!!!!!!!!!!!!!!!!! testDeadlockQueue4")
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
