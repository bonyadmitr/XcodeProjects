import Foundation

extension Optional {
    func assert(or defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
        switch self {
        case .none:
            assertionFailure()
            return defaultValue()
        case .some(let value):
            return value
        }
    }
}
