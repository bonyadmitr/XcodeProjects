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
