import UIKit

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

extension UISearchBar {
    
    /// you can use appearance like:
    //UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
    var textField: UITextField {
        if #available(iOS 13, *) {
            return searchTextField
        } else {
            // TODO: assert
            return value(forKey: "_searchField") as? UITextField ?? UITextField()
        }
    }
    
    /// iOS 13 Search Bar https://medium.com/better-programming/whats-new-in-the-ios-13-search-bar-f87c1e47f8d0
    /// you can use new iOS 13 api:
    //UISearchController.automaticallyShowsCancelButton = false
    //searchBar.showsCancelButton = true
    var cancelButton: UIButton? {
        if #available(iOS 13, *) {
            return firstSubview(of: UIButton.self)
        } else {
            // TODO: check iOS <= 12
            /// iOS 13 crash: 'Access to UISearchBar's _cancelButton ivar is prohibited. This is an application bug
            return value(forKey: "_cancelButton") as? UIButton
        }
    }
}

extension UIFont {
    
    // TODO: add guard "is already dynamic" to prevent crash
    func dynamic() -> UIFont {
        return UIFontMetrics.default.scaledFont(for: self)
    }
}

extension UIView {
    
    func firstSubview<T: UIView>(of: T.Type) -> T? {
        
        func checkViewForType(_ inputView: UIView) -> T? {
            if let view = inputView as? T {
                return view
            }
            for view in inputView.subviews {
                if let view2 = checkViewForType(view) {
                    return view2
                }
            }
            return nil
        }
        
        for view in subviews {
            if let view2 = checkViewForType(view) {
                return view2
            }
        }
        return nil
    }
    
    /// returns all subviews except self
    func allSubviews<T: UIView>(of: T.Type) -> [T] {
        var typeSubviews = [T]()
        
        func checkViewForType(_ view: UIView) {
            if let view = view as? T {
                typeSubviews.append(view)
            }
            view.subviews.forEach { checkViewForType($0) }
        }
        
        subviews.forEach { checkViewForType($0) }
        return typeSubviews
    }

}
