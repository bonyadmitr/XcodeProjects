import UIKit

protocol NibInitiable {}

extension NibInitiable where Self: UIView {
    static func initFromNib() -> Self {
        let nibName = String(describing: Self.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        if let instanse = nib.instantiate(withOwner: nil, options: nil).first as? Self {
            return instanse
        } else {
            assertionFailure("Didn't load: \(nibName)")
            return Self()
        }
    }
}

extension NibInitiable where Self: UIViewController {
    static func initFromNib() -> Self {
        let nibName = String(describing: Self.self)
        return self.init(nibName: nibName, bundle: nil)
    }
}
