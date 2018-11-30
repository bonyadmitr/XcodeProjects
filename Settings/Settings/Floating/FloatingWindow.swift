//
//  FloatingWindow.swift
//  WindowFloating
//
//  Created by Bondar Yaroslav on 4/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

#if DEBUG
import UIKit

protocol FloatingWindowDelegate: class {
    func isPointEvent(point: CGPoint) -> Bool
}

final class FloatingWindow: UIWindow {
    
    weak var delegate: FloatingWindowDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        windowLevel = UIWindow.Level.statusBar - 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        assertionFailure("should not be used")
        super.init(coder: aDecoder)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return delegate?.isPointEvent(point: point) ?? false
    }
}
#endif
