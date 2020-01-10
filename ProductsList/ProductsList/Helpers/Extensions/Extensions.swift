import Foundation

typealias ErrorCompletion = (Error?) -> Void

/// there is no CustomDebugStringConvertible bcz of error:
/// Extension of protocol 'Error' cannot have an inheritance clause
extension Error {
    var debugDescription: String {
        return String(describing: self)
    }
}

//extension Data {
//    var stringValue: String {
//        return String(data: self, encoding: .utf8) ?? String(describing: self)
//    }
//}

//extension Collection where Indices.Iterator.Element == Index {
//
//    /// article https://medium.com/flawless-app-stories/say-goodbye-to-index-out-of-range-swift-eca7c4c7b6ca
//    subscript(safe index: Index) -> Iterator.Element? {
//        return (startIndex <= index && index < endIndex) ? self[index] : nil
//    }
//}
