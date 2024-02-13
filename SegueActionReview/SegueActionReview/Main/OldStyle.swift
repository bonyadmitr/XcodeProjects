
final class OldStyleTextController: UIViewController {
    
    @IBOutlet private weak var textLabel: UILabel!
    
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let text = text else {
            assertionFailure()
            return
        }
        
        textLabel.text = text
    }
    
}
