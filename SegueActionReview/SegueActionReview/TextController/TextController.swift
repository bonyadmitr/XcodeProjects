import UIKit

final class TextController: UIViewController, StoryboardInitable {
    
    @IBOutlet private weak var textLabel: UILabel!
    
    private let text: String
    
    /// `super.init(nibName: nil, bundle: nil)` not working for Storyboard. only for xib. so use `StoryboardInitable`
    //init(text: String) {
    //    self.text = text
    //    super.init(nibName: nil, bundle: nil)
    //}
    
    static func initFromStoryboard(text: String) -> Self {
        _initFromStoryboard { Self.init(coder: $0, text: text) }!
    }
    
    init?(coder: NSCoder, text: String) {
        self.text = text
        super.init(coder: coder)
    }
    
