//
//  StoryboardInitable.swift
//  SegueActionReview
//
//  Created by Yaroslav Bondar on 02.02.2024.
//

import UIKit

/**
 `super.init(nibName: nil, bundle: nil)` not working for Storyboard. only for xib
 
 Usage
 
 static func initFromSB(text: String) -> TextController {
 _initFromSB { Self.init(coder: $0, text: text) }!
 }
 */
protocol StoryboardInitable: UIViewController {
    static func _initFromStoryboard <T: UIViewController>(storyboardName: String?, identifier: String?, bundle: Bundle?, _ creator: @escaping ((NSCoder) -> T?)) -> T?
}
extension StoryboardInitable {
    static func _initFromStoryboard <T: UIViewController>(storyboardName: String? = nil, identifier: String? = nil, bundle: Bundle? = nil, _ creator: @escaping ((NSCoder) -> T?)) -> T? {
        let storyboard = UIStoryboard(name: storyboardName ?? String(describing: T.self), bundle: bundle)
        if let identifier {
            return storyboard.instantiateViewController(identifier: identifier, creator: creator)
        } else {
            return storyboard.instantiateInitialViewController(creator: creator)
        }
    }
}
//extension UIViewController {
//    static func _initFromSB <T: UIViewController>(_ creator: @escaping ((NSCoder) -> T?)) -> T? {
//        UIStoryboard(name: String(describing: T.self), bundle: nil).instantiateInitialViewController(creator: creator)
//    }
//}
