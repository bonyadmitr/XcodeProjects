//
//  AutoTextView.swift
//  AnimationStackView
//
//  Created by Yaroslav Bondar on 28.09.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import UIKit

class AutoTextView: UITextView {

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        print(contentSize)
//        DispatchQueue.once(executeToken: "setContentOffsetToken") { [weak self] in
//            self?.setContentOffset(CGPoint(), animated: false)
//        }
//    }
    
    override var contentSize:CGSize {
        didSet { invalidateIntrinsicContentSize() }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        //contentSize.width
        //UIViewNoIntrinsicMetric
        //contentSize.height
        return CGSize(width: CGFloat.greatestFiniteMagnitude, height: contentSize.height)
    }
}

public extension DispatchQueue {
    private static var _tokenTracker = [String]()
    
    public class func once(executeToken: String, block:(Void)->Void) {
        objc_sync_enter(self);
        defer { objc_sync_exit(self) }
        
        if _tokenTracker.contains(executeToken) {
            return
        }
        
        _tokenTracker.append(executeToken)
        block()
    }
}

/*
Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.
 */
