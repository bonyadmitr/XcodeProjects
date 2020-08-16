import UIKit

/// there is a bug on keyboardWillHideWithState with black background on the simulator only
class KeyboardScrollController: ScrollController {
    private let keyboardView = KeyboardView()
    
    override func loadView() {
        view = keyboardView
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
//        keyboardView.originalHeight = size.height
//        keyboardView.frame.size.height = size.height
//        print("-", size.height)
    }
}
final class KeyboardView: UIView {
    
    private let keyboardStateListener2 = KeyboardStateListener2()
    var originalHeight: CGFloat = 0
    
    override var frame: CGRect {
//        willSet {
//            if frame.width != newValue.width {
//                //                print(frame.height, oldValue.height)
//                print("rotate")
//
//                originalHeight = newValue.height
////                newValue.size.height = originalHeight
//            }
//        }
        didSet {
            if frame.width != oldValue.width {
//                print(frame.height)
                print("rotate")
                
                originalHeight = frame.height
//                frame.size.height = originalHeight
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addTapGestureToHideKeyboard()
//        originalHeight = bounds.height
        
        keyboardStateListener2.add(view: self, willShow: { [weak self] keyboardHeight in
            guard let self = self else {
                return
            }
//            print(self.frame.height)
            self.originalHeight = self.frame.height// - 14//(739 - 725)//iPhone 11
            self.frame.size.height -= keyboardHeight
            print(self.frame.height)
            self.layoutIfNeeded()
            
        }, willHide: { [weak self] keyboardHeight in
            guard let self = self else {
                return
            }
            self.frame.size.height = self.originalHeight
            print(self.frame.height)
            self.layoutIfNeeded()
        })
    }
    
}

class KeyboardScrollController3: ScrollController {
//    private let keyboardStateListener = KeyboardStateListener()
    
    private let keyboardStateListener2 = KeyboardStateListener2()
    private var originalHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

//        keyboardStateListener.delegate = self
        view.addTapGestureToHideKeyboard()

        originalHeight = view.frame.height
        keyboardStateListener2.add(view: view, willShow: { [weak self] keyboardHeight in
            guard let self = self else {
                return
            }
            self.view.frame.size.height -= keyboardHeight
            self.view.layoutIfNeeded()

        }, willHide: { [weak self] keyboardHeight in
            guard let self = self else {
                return
            }
            self.view.frame.size.height = self.originalHeight
            self.view.layoutIfNeeded()
        })
    }
}

/// there is a bug on keyboardWillHideWithState with black background on the simulator only
class KeyboardScrollController2: ScrollController {
    private let keyboardStateListener = KeyboardStateListener()
    private var oldHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardStateListener.delegate = self
        view.addTapGestureToHideKeyboard()
    }
}
extension KeyboardScrollController2: KeyboardHelperDelegate {
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
