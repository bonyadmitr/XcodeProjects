import UIKit

extension UIView {
    
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func closeKeyboard() {
        let view: UIView = window ?? self
        view.endEditing(true)
    }
    
}

// TODO: optimize by protocol or subclass (example: AdvancedScrollView)
extension UIScrollView {
    
    func scroll(to view: UIView) {
        let rect = convert(view.frame.offsetBy(dx: 0, dy: 8), to: self)
        scrollRectToVisible(rect, animated: true)
    }

    func scroll(to views: [UIView]) {
        if views.isEmpty {
            return
        }
        
        let rects: [CGRect] = views.map { convert($0.frame, to: self) }
        
        /// check for isEmpty is above
        let firstRect = rects[0]
        
        // TODO: test old
        //let unionRect: CGRect = rects.dropFirst().reduce(into: firstRect) { $0.union($1) }
        let unionRect: CGRect = rects.dropFirst().reduce(firstRect) { $0.union($1) }
        
        scrollRectToVisible(unionRect, animated: true)
    }
    
}

extension UIView {
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
    
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        } else {
            return leadingAnchor
        }
    }
    
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        } else {
            return trailingAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }
    
    func pinToSuperviewEdges(offset: CGFloat = 0.0) {
        guard let superview = superview else {
            assertionFailure("view call addSubview")
            return
        }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: offset),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -offset),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: offset),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -offset),
        ])
    }
    
    func safePinToSuperviewEdges(offset: CGFloat = 0.0) {
        guard let superview = superview else {
            assertionFailure("view call addSubview")
            return
        }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeTopAnchor, constant: offset),
            bottomAnchor.constraint(equalTo: superview.safeBottomAnchor, constant: -offset),
            leadingAnchor.constraint(equalTo: superview.safeLeadingAnchor, constant: offset),
            trailingAnchor.constraint(equalTo: superview.safeTrailingAnchor, constant: -offset),
            
            /// temp
            //safeTopAnchor.constraint(equalTo: superview.safeTopAnchor, constant: offset),
            //safeBottomAnchor.constraint(equalTo: superview.safeBottomAnchor, constant: -offset),
            //safeLeadingAnchor.constraint(equalTo: superview.safeLeadingAnchor, constant: offset),
            //safeTrailingAnchor.constraint(equalTo: superview.safeTrailingAnchor, constant: -offset),
        ])
    }
    
}
