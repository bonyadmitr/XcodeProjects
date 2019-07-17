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
