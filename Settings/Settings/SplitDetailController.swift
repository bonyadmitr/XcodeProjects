//
//  SplitDetailController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 28/09/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class SplitDetailController: UIViewController, ChildHandler, BackButtonActions {
    
    /// initial vc need for split controller
    var childVC: UIViewController = LanguageSelectController()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        /// in viewDidLoad it will be with changing animation from storyboard title
        title = childVC.title
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVC()
        //removeBackButtonTitle()
    }
    
    private func addChildVC() {
        add(childController: childVC)
    }
}

// MARK: - UIStateRestoration
extension SplitDetailController {
    
    /// Constants for state restoration.
    private static let restoreChildVC = "childVCKey"
//    private static let restoreChildControllers = "restoreChildControllers"
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        /// If the view has not been loaded, the app will crash
        /// upon accessing force-unwrapped outlets, e.g., `slider`.
        guard isViewLoaded else {
            return
        }
        
        coder.encode(childVC, forKey: SplitDetailController.restoreChildVC)
//        coder.encode(childViewControllers, forKey: SplitDetailController.restoreChildControllers)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        assert(isViewLoaded, "We assume the controller is never restored without loading its view first.")
        
//        if let childControllers = coder.decodeObject(forKey: SplitDetailController.restoreChildControllers) as? [UIViewController] {
//            
//            if childControllers.isEmpty {
//                /// called in bcz of splitController
////                assertionFailure()
//                _ = navigationController?.popViewController(animated: false)
//                return
//            }
//            
//            title = childControllers.first?.title
//            childControllers.forEach { add(childController: $0)}
//        }
        
        /// can be used coder.containsValue(forKey
        if let childVC = coder.decodeObject(forKey: SplitDetailController.restoreChildVC) as? UIViewController {
            self.childVC = childVC
            title = childVC.title
//            extendedLayoutIncludesOpaqueBars = false
//            automaticallyAdjustsScrollViewInsets = false
            
            /// need for iOS 10. don't need for iOS 11
            edgesForExtendedLayout = [.bottom]
            
            /// viewDidLoad called first and will add child controller by default
            childVC.removeFromParentVC()
            addChildVC()
        } else {
            /// called in bcz of splitController
//            assertionFailure()
//            _ = navigationController?.popViewController(animated: false)
        }
    }
    
    override func applicationFinishedRestoringState() {
        super.applicationFinishedRestoringState()
        
    }
}
