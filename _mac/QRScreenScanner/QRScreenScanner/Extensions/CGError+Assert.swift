import CoreGraphics

extension CGError {
    
    func require() -> CGError {
        assert(self == .success, "reason: \(self)")
        return self
    }
    
    func handleError() {
        assert(self == .success, "reason: \(self)")
    }
}
