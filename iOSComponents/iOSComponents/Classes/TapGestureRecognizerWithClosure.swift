//
//  TapGestureRecognizerWithClosure.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 8/24/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class TapGestureRecognizerWithClosure: UITapGestureRecognizer {
    
    private let closure: VoidHandler
    
    init(closure: @escaping VoidHandler) {
        self.closure = closure
        super.init(target: nil, action: nil)
        addTarget(self, action: #selector(runAction))
    }
    
    @objc private func runAction() {
        closure()
    }
}
