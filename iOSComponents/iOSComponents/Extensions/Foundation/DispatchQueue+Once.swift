//
//  DispatchQueue+Once.swift
//  Swift3Best
//
//  Created by Bondar Yaroslav on 12.01.17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    private static var _tokenTracker = [String]()
    
    public class func once(executeToken: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _tokenTracker.contains(executeToken) {
            return
        }
        
        _tokenTracker.append(executeToken)
        block()
    }
}

//#usage
//DispatchQueue.once(executeToken: "setContentOffsetToken") { [weak self] in
//    // self?.setContentOffset(CGPoint(), animated: false)
//}
