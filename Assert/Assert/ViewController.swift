//
//  ViewController.swift
//  Assert
//
//  Created by Bondar Yaroslav on 8/30/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testDispatchAssert()
        testOptionalAssert()
        
        
        view.backgroundColor = .lightGray
        print("- viewDidLoad")
    }
    
    private func testDispatchAssert() {
        
        if #available(iOS 10.0, *) {
            dispatchAssert(condition: .onQueue(.main))
        }
        
        assertMainQueue()
        assertMainThread()
        
        DispatchQueue.global().async {
            assertBackgroundQueue()
            assertBackgroundThread()
        }
    }
    
    private func testOptionalAssert() {
        let text: String? = nil//"some"
        
        let unwrapedText = text.assert(or: "")
        print(unwrapedText)
        
        text.assertExecute { print($0) }
    }
}

extension Optional {
    func assert(or defaultValue: Wrapped, file: String = #file, line: Int = #line) -> Wrapped {
        switch self {
        case .none:
            assertionFailure("\((file as NSString).lastPathComponent):\(line) is nil")
            return defaultValue
        case .some(let value):
            return value
        }
    }
    
    /**
     it is nonescaping, so there is no perfermance issue
     
     text.assertExecute { print($0) }
     
     vs
     
     if let text = text {
     print(text)
     } else {
     assertionFailure()
     }
     
     */
    // TODO: check with and without "rethrows"
    func assertExecute(file: String = #file, line: Int = #line, _ action: (Wrapped) throws -> Void) rethrows {
        switch self {
        case .none:
            assertionFailure("\((file as NSString).lastPathComponent):\(line) is nil")
        case .some(let value):
            try action(value)
        }
    }
}
