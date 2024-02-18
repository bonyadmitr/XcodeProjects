final class TextNibController: UIViewController {
    
    @IBOutlet private weak var textLabel: UILabel!
    
    private let text: String
    
    init(text: String) {
        self.text = text
        /// working for xib
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(coder: NSCoder, text: String) {
        self.text = text
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel.text = text
    }
    
}


extension UIViewController {
    @IBSegueAction private func onShowTextNibShared(_ coder: NSCoder) -> UIViewController? {
        TextNibController(coder: coder, text: "Nib Shared")
    }
}




extension UINavigationController {
    @IBSegueAction private func showNavBarText(_ coder: NSCoder) -> UIViewController? { fatalError("will never be called. implemented in presentingViewController") }
}
