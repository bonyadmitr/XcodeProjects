import Foundation

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
    
    @available(iOS 10.0, *)
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


/**
 Первый прогон
 finish count(where 29.021828055381775
 finish countFILTER(where 31.501862049102783
 finish countConcurrent(where 22.39603304862976
 
 второй
 finish count(where 28.15902888774872
 finish countFILTER(where 31.33501398563385
 finish countConcurrent(where 22.139133095741272
 */
func globalTestCountWhere() {
    var array = Array(repeating: 0, count: 1_000_000)
    
    DispatchQueue.concurrentPerform(iterations: array.count) { i in
        array[i] = i
    }
    
    print("start")
    
    let date1 = Date()
    let count1 = array.countLoop(where: { $0 > 50_000 })
    print("finish countLoop", count1, -date1.timeIntervalSinceNow)
    
    let date2 = Date()
    let count2 = array.countFilter(where: { $0 > 50_000 })
    print("finish countFilter", count2, -date2.timeIntervalSinceNow)
    
    let date3 = Date()
    let count3 = array.countConcurrent(where: { $0 > 50_000 })
    print("finish countConcurrent", count3, -date3.timeIntervalSinceNow)
}

func globalTest() {
    
    /// https://www.hackingwithswift.com/example-code/language/how-to-pass-the-fizz-buzz-test
    func fizzbuzz(number: Int) -> String {
        switch (number % 3 == 0, number % 5 == 0) {
        case (true, false):
            return "Fizz"
        case (false, true):
            return "Buzz"
        case (true, true):
            return "FizzBuzz"
        case (false, false):
            return String(number)
        }
    }
    
    
    let limit = 1_000_000_000
    print(
        "time:",
        Benchmark.one {
//            DispatchQueue.concurrentPerform(iterations: limit) { i in
//                _ = fizzbuzz(number: i)
//            }
            
            for i in 1...limit {
                //print(fizzbuzz(number: i))
                _ = fizzbuzz(number: i)
            }
            
            /// swift github search https://github.com/search?l=swift&q=FizzBuzz&type=Repositories
            /// all lang https://rosettacode.org/wiki/FizzBuzz#Swift
            /// perfermance C https://habr.com/ru/post/540136/
            
            /// https://github.com/rsha256/shortest-fizzbuzz/blob/master/Swift.swift
//            func fizzBuzz(_ numberOfTurns: Int) {
//                guard numberOfTurns >= 1 else {
//                    print("Number of turns must be >= 1")
//                    return
//                }
//
//                for i in 1...numberOfTurns {
//                    switch (i.isMultiple(of: 3), i.isMultiple(of: 5)) {
//                    case (false, false):
//                        print("\(i)")
//                    case (true, false):
//                        print("Fizz")
//                    case (false, true):
//                        print("Buzz")
//                    case (true, true):
//                        print("Fizz Buzz")
//                    }
//                }
//            }
            
//
//                switch (i % 3 == 0, i % 5 == 0) {
//                case (true, false):
//                    print("Fizz")
//                case (false, true):
//                    print("Buzz")
//                case (true, true):
//                    print("FizzBuzz")
//                case (false, false):
//                    print(i)
//                }
//
//                /// https://m.habr.com/ru/post/540136/
////                if (0 == i % 3) {
////                    if (0 == i % 5) {
////                        print("FizzBuzz");
////                    } else {
////                        print("Fizz");
////                    }
////                } else if (0 == i % 5) {
////                    print("Buzz");
////                } else {
////                    print("%d", i);
////                }
            
            
        }
    )
    
    
}
