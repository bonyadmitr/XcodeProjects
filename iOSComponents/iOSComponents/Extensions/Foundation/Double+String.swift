import Foundation

extension Double {
    /// Returns the receiver's string representation, truncated to the given number of decimal places.
    /// - parameter decimalPlaces: The maximum number of allowed decimal places
    public mutating func toString(decimalPlaces decimalPlaces: Int) -> String {
        let power = pow(10.0, Double(decimalPlaces))
        return "\(round(power * self) / power)"
    }
}
