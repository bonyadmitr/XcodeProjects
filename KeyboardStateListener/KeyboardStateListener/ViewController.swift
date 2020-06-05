import UIKit

final class SomeStackScrollingController: StackScrollingController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.spacing = 8
        
        for i in 1...100 {
            let label = UILabel()
            label.backgroundColor = .lightGray
            label.textAlignment = .center
            label.text = "Label \(i)"
            
            stackView.addArrangedSubview(label)
        }
extension UIStackView {
    
    func addArrangedSubviewAnimated(_ view: UIView) {
        view.isHidden = true
        addArrangedSubview(view)
        UIView.animate {
            view.isHidden = false
        }
    }
    
}

extension UIView {
    
    static let animationDuration: TimeInterval = 0.25
    
    static func animate(animations: @escaping () -> Void) {
        animate(withDuration: animationDuration, animations: animations)
    }
    static func animate(animations: @escaping () -> Void, completion:  @escaping () -> Void) {
        animate(withDuration: animationDuration, animations: animations, completion: { _ in completion() })
    }
    
    func removeFromStackViewAnimated() {
        UIView.animate(animations: {
            self.isHidden = true
        }, completion: {
            /// view.isHidden = true + stackView.removeArrangedSubview(view) now working
            self.removeFromSuperview()
        })
    }
}

// TODO: contentView or stackView insets
class StackScrollingController: KeyboardScrollController {
    
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            /// same
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            //contentView.bottomAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor),
        ])
        
    }
    
}

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
