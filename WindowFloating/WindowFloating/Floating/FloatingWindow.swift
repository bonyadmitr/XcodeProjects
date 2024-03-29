//
//  FloatingWindow.swift
//  WindowFloating
//
//  Created by Bondar Yaroslav on 4/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol FloatingWindowDelegate: class {
    func isPointEvent(point: CGPoint) -> Bool
}

final class FloatingWindow: UIWindow {
    
    weak var delegate: FloatingWindowDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        windowLevel = UIWindowLevelStatusBar - 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return delegate?.isPointEvent(point: point) ?? false
    }
}
