//
//  TextNibController.swift
//  SegueActionReview
//
//  Created by Yaroslav Bondar on 29.01.2024.
//

import UIKit

/// !!! Storyboard ID should be empty + remove view from controller in storyboard
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



/// not working as tab bar https://useyourloaf.com/blog/using-@ibsegueaction-with-tab-bar-controllers/
//final class NavBarSenderController: UINavigationController {
//    
//    private let text: String
//    
//    init?(coder: NSCoder, text: String) {
//        self.text = text
//        super.init(coder: coder)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//    
//    @IBSegueAction private func showNavBarSender111(_ coder: NSCoder) -> UIViewController? {
//        TextNibController(coder: coder, text: text)
//    }
//    
//}

extension UINavigationController {
    @IBSegueAction private func showNavBarText(_ coder: NSCoder) -> UIViewController? { fatalError("will never be called. implemented in presentingViewController") }
}

/*
 #0    0x0000000102de09f6 in UIViewController.showNavBarSenderController(_:text:) at /Users/yaroslav.bondar/Downloads/SegueActionReview/SegueActionReview/TextNibController/TextNibController.swift:68
 #1    0x0000000102de0b10 in @objc UIViewController.showNavBarSenderController(_:text:) ()
 #2    0x00007ff80563d5e7 in -[UIClassSwapper performSelectorForObject:selector:withObject:withObject:withObject:] ()
 #3    0x00007ff80563db32 in -[UIClassSwapper initWithCoder:] ()
 #4    0x00007ff804ad37c4 in UINibDecoderDecodeObjectForValue ()
 #5    0x00007ff804ad39ce in UINibDecoderDecodeObjectForValue ()
 #6    0x00007ff804ad34f2 in -[UINibDecoder decodeObjectForKey:] ()
 #7    0x00007ff80563d266 in -[NSCoder(UIIBDependencyInjectionInternal) _decodeObjectsAndTrackChildViewControllerIndexWithParent:forKey:] ()
 #8    0x00007ff8051de033 in -[UIViewController initWithCoder:] ()
 #9    0x00007ff8050e11cd in -[UINavigationController initWithCoder:] ()
 #10    0x0000000102ddf898 in NavBarSenderController.init(coder:text:) at /Users/yaroslav.bondar/Downloads/SegueActionReview/SegueActionReview/TextNibController/TextNibController.swift:55
 #11    0x0000000102ddf7ba in NavBarSenderController.__allocating_init(coder:text:) ()
 #12    0x0000000102de5512 in ViewController.showNavBarText(_:) at /Users/yaroslav.bondar/Downloads/SegueActionReview/SegueActionReview/Main/ViewController.swift:172

 */
