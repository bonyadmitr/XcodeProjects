import UIKit

final class SomeScrollingController: KeyboardScrollController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.addTapGestureToHideKeyboard()
        
        let edgeInset: CGFloat = 16
        
        let topTextField = UITextField()
        topTextField.borderStyle = .roundedRect
        
        topTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topTextField)
        
        topTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: edgeInset).isActive = true
        topTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -edgeInset).isActive = true
        topTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: edgeInset).isActive = true
        
        
        let bottomTextField = UITextField()
        bottomTextField.borderStyle = .roundedRect
        
        bottomTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bottomTextField)
        
        bottomTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: edgeInset).isActive = true
        bottomTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -edgeInset).isActive = true
        bottomTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -edgeInset).isActive = true
        
        //bottomTextField.topAnchor.constraint(greaterThanOrEqualTo: topTextField.bottomAnchor, constant: -edgeInset).isActive = true
        
        
        
        let label = UILabel()
        if #available(iOS 13.0, *) {
            label.backgroundColor = .secondarySystemBackground
        }
        label.text = "Label"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        label.heightAnchor.constraint(equalToConstant: 400).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: edgeInset).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -edgeInset).isActive = true
        label.topAnchor.constraint(equalTo: topTextField.bottomAnchor, constant: edgeInset).isActive = true
        
        //label.bottomAnchor.constraint(equalTo: bottomTextField.topAnchor, constant: -edgeInset).isActive = true
        
        //label.bottomAnchor.constraint(greaterThanOrEqualTo: bottomTextField.topAnchor, constant: -edgeInset).isActive = true
        bottomTextField.topAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor, constant: edgeInset).isActive = true
    }
}

/// there is a bug on keyboardWillHideWithState with black background on the simulator only
class KeyboardScrollController: ScrollController {
    private let keyboardStateListener = KeyboardStateListener()
    
    private var oldHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardStateListener.delegate = self
        view.addTapGestureToHideKeyboard()
    }
}

extension KeyboardScrollController: KeyboardHelperDelegate {
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardWillShowWithState state: KeyboardState) {
        let coveredHeight = state.keyboardHeightForView(view)
        
        /// coveredHeight == 0 when changed text enter responder (example: focus between 2 textFields)
        if coveredHeight == 0 {
            return
        }
        
        oldHeight = view.frame.size.height
        view.frame.size.height -= coveredHeight
        
        state.animate {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardWillHideWithState state: KeyboardState) {
        view.frame.size.height = oldHeight
        state.animate {
            self.view.layoutIfNeeded()
        }
    }
}

class ScrollController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var backgroundColor: UIColor? {
        get {
            return view.backgroundColor
        }
        set {
            view.backgroundColor = newValue
            contentView.backgroundColor = newValue
            scrollView.backgroundColor = newValue
        }
    }
    
//    override func loadView() {
//        view = scrollView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isOpaque = true
        scrollView.isOpaque = true
        contentView.isOpaque = true
        
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.safePinToSuperviewEdges()
        
        
        setupContentView()
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        
        /// layout
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.pinToSuperviewEdges()
        
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            heightConstraint
        ])
        
    }
}

final class KeyboardHideController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addTapGestureToHideKeyboard()
    }
}

final class ViewController: UIViewController {

    private let keyboardStateListener = KeyboardStateListener()
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var someTextField: UITextField!
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    /// same as scrollViewBottomConstraint
    private lazy var scrollViewBottomConstraint2: NSLayoutConstraint? = {
        return self.view.constraints.first {
            //return $0.secondAttribute == .bottom && $0.secondItem === scrollView// && $0.firstAttribute == .bottom
            return $0.secondAttribute == .bottom && $0.secondItem is UIScrollView
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardStateListener.delegate = self
        
        //scrollView.subviews.first?.backgroundColor = UIColor.lightGray
        //scrollView.backgroundColor = UIColor.lightGray
        //view.backgroundColor = UIColor.lightGray
        
        view.addTapGestureToHideKeyboard()
    }
}
extension ViewController: KeyboardHelperDelegate {
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardWillShowWithState state: KeyboardState) {
        let coveredHeight = state.keyboardHeightForView(scrollView)
        
        /// coveredHeight == 0 when changed text enter responder (example: focus between 2 textFields)
        if coveredHeight == 0 {
            return
        }
//        state.animate {
//            self.scrollView.contentInset.bottom = coveredHeight
//        }
        
//        self.scrollView.frame.size.height -= coveredHeight
        
//        scrollViewBottomConstraint.constant = coveredHeight
        scrollViewBottomConstraint2?.constant = coveredHeight
        UIView.animate(withDuration: state.animationDuration) {
            self.view.layoutIfNeeded()
        }
        
        
//        self.scrollView.contentInset.bottom = coveredHeight
//        self.scrollView.scrollIndicatorInsets.bottom = coveredHeight
        
        
        
        
        
//        let scrollPoint = CGPoint(x: 0, y: someTextField.frame.origin.y - coveredHeight + 16)
//        scrollView.setContentOffset(scrollPoint, animated: true)
        
//        self.scrollView.contentOffset = CGPoint(x: 0, y: 1000)
//        self.scrollView.scroll(to: self.someTextField)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.scrollView.scroll(to: self.someTextField)
//        }
    }
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardDidShowWithState state: KeyboardState) {
//        let coveredHeight = state.keyboardHeightForView(scrollView)
        //        state.animate {
        //            self.scrollView.contentInset.bottom = coveredHeight
        //        }
        
//        self.scrollView.contentInset.bottom = coveredHeight
//        self.scrollView.scrollIndicatorInsets.bottom = coveredHeight
        
//                let scrollPoint = CGPoint(x: 0, y: someTextField.frame.origin.y - coveredHeight + 16)
//                scrollView.setContentOffset(scrollPoint, animated: true)
        
//        self.scrollView.scroll(to: self.someTextField)
    }
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardWillHideWithState state: KeyboardState) {
//        state.animate {
//            self.scrollView.contentInset.bottom = 0
//        }
        
//        scrollView.contentInset.bottom = 0
//        scrollView.scrollIndicatorInsets.bottom = 0
        
//        scrollViewBottomConstraint.constant = 0
        scrollViewBottomConstraint2?.constant = 0
        UIView.animate(withDuration: state.animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}




private extension UIView {
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func closeKeyboard() {
        let view: UIView = window ?? self
        view.endEditing(true)
    }
}

//final class AdvancedScrollView: UIScrollView {
//    func scrollToView(_ view: UIView) {
//        let rect = convert(view.frame, to: self)
//        scrollRectToVisible(rect, animated: true)
//    }
//
//    func scrollToViews(_ views: [UIView]) {
//        if views.isEmpty {
//            return
//        }
//
//        let rects: [CGRect] = views.map { convert($0.frame, to: self) }
//
//        /// check for isEmpty is above
//        let firstRect = rects[0]
//        let unionRect: CGRect = rects.dropFirst().reduce(into: firstRect) { $0.union($1) }
//
//        scrollRectToVisible(unionRect, animated: true)
//    }
//}

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
