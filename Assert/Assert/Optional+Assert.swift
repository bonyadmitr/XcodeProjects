import Foundation

/// Require: unwrap or crash https://github.com/JohnSundell/Require

extension Optional {
    
    /**
     it is nonescaping, so there is no perfermance issue
     
         text.assertExecute { print($0) }
     
     vs
     
         if let text = text {
             print(text)
         } else {
             assertionFailure()
         }

     
     */
    func assertExecute(file: String = #file, line: Int = #line, _ action: (Wrapped) throws -> Void) rethrows {
        switch self {
        case .none:
            assertionFailure("\((file as NSString).lastPathComponent):\(line) is nil")
        case .some(let value):
            try action(value)
        }
    }
    
    func assert(or defaultValue: Wrapped, file: String = #file, line: Int = #line) -> Wrapped {
        switch self {
        case .none:
            assertionFailure("\((file as NSString).lastPathComponent):\(line) is nil")
            return defaultValue
        case .some(let value):
            return value
        }
    }
}


protocol Emptyably {
    init()
}

extension String: Emptyably {}

extension URL: Emptyably {
    init() {
        self.init(fileURLWithPath: "")
    }
}

extension Optional where Wrapped: Emptyably {
    func assertOrEmpty(file: String = #file, line: Int = #line) -> Wrapped {
        switch self {
        case .none:
            assertionFailure("\((file as NSString).lastPathComponent):\(line) is nil")
            return Wrapped()
        case .some(let value):
            return value
        }
    }
}

extension URL: ExpressibleByStringLiteral {
    /// using: let url: URL = "https://www.google.com/"
    public init(stringLiteral value: StaticString) {
        self = URL(string: "\(value)").assertOrEmpty()
    }
}

