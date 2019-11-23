import Foundation

protocol ClassNameable {
    static func className() -> String
    func className() -> String
}

extension ClassNameable {
    static func className() -> String {
        return String(describing: self.self)
    }
    
    func className() -> String {
        return String(describing: type(of: self))
    }
}

extension NSObject: ClassNameable {}
