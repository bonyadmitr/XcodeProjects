import Foundation

/// @objc and NSObject needs for NSSortDescriptor
final class History: NSObject, Codable {
    @objc let date: Date
    @objc let value: String
    
    init(date: Date, value: String) {
        self.date = date
        self.value = value
    }
}
