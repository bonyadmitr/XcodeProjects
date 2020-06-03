import UIKit

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



/// couldn't use `override func loadView` with `view = scrollView`
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
