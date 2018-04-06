//
//  ClosureTapGesture.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

typealias TapGestureHandler = (UITapGestureRecognizer) -> Void

final class ClosureTapGesture: UITapGestureRecognizer {
    
    private let closure: TapGestureHandler
    
    init(closure: @escaping TapGestureHandler) {
        self.closure = closure
        super.init(target: nil, action: nil)
        addTarget(self, action: #selector(runAction))
    }
    
    @objc private func runAction(_ sender: UITapGestureRecognizer) {
        closure(sender)
    }
}
