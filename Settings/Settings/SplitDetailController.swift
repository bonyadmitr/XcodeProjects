//
//  SplitDetailController.swift
//  Settings
//
//  Created by Bondar Yaroslav on 28/09/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class SplitDetailController: UIViewController {
    
    var childVC: UIViewController?
    
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
        title = childVC?.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVC()
    }
    
    private func addChildVC() {
        guard let childVC = childVC else {
//            assertionFailure()
            return
        }
        
        add(childController: childVC)
    }
    
}

// MARK: - UIStateRestoration
extension SplitDetailController {
    
    /// Constants for state restoration.
    private static let restoreChildVC = "childVCKey"
    private static let restoreChildControllers = "restoreChildControllers"
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        coder.encode(childVC, forKey: SplitDetailController.restoreChildVC)
        coder.encode(childViewControllers, forKey: SplitDetailController.restoreChildControllers)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        if let childControllers = coder.decodeObject(forKey: SplitDetailController.restoreChildControllers) as? [UIViewController] {
            
            if childControllers.isEmpty {
//                assertionFailure()
                _ = navigationController?.popViewController(animated: false)
                return
            }
            
            automaticallyAdjustsScrollViewInsets = false
            title = childControllers.first?.title
            childControllers.forEach { add(childController: $0)}
        }
        
        /// can be used coder.containsValue(forKey
//        if let childVC = coder.decodeObject(forKey: SplitDetailController.restoreChildVC) as? UIViewController {
//            self.childVC = childVC
//            automaticallyAdjustsScrollViewInsets = false
//            addChildVC()
//        } else {
//            assertionFailure()
//            _ = navigationController?.popViewController(animated: false)
//        }
    }
    
    override func applicationFinishedRestoringState() {
        super.applicationFinishedRestoringState()
        
    }
}

// TODO: ParantController/ChildHandler/ChildManager
extension UIViewController {
    
    func add(childController: UIViewController, to container: UIView? = nil) {
        
        var holderView = self.view!
        if let container = container {
            holderView = container
        }
        
        addChildViewController(childController)
        childController.view.frame = holderView.bounds
        childController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        holderView.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
    }
    
    func removeFromParentVC() {
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}
