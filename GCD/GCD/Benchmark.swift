import Foundation

// TODO: create class nd functions for comparing
enum Benchmark {
    static func one(block: () -> Void) -> TimeInterval {
        let startTime = CFAbsoluteTimeGetCurrent()
        block()
        let endTime = CFAbsoluteTimeGetCurrent()
        let totalTime = endTime - startTime
        return totalTime
    }
    
    static func average(iterations: Int = 10, block: () -> Void) -> (average: TimeInterval, all: [TimeInterval]) {
        let iterationsResults: [TimeInterval] = (0..<iterations).map { _ in one(block: block) }
        let accumulatedResult = iterationsResults.reduce(0, +) / TimeInterval(iterations)
        return (accumulatedResult, iterationsResults)
    }
}
