//
//  TextController.swift
//  SegueActionReview
//
//  Created by Yaroslav Bondar on 29.01.2024.
//

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
    
    required init?(coder: NSCoder) {
        assertionFailure("use @IBSegueAction or initFromStoryboard")
        text = "unknown"
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel.text = text
    }
    
}


extension UIViewController {
    @IBSegueAction private func onShowTextShared(_ coder: NSCoder) -> UIViewController? {
        TextController(coder: coder, text: "Shared")
    }
}
