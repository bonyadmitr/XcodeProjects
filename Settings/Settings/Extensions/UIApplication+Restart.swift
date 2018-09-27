//
//  UIApplication+Restart.swift
//  LocalizationManager
//
//  Created by Bondar Yaroslav on 17/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIApplication {
    
    func animateReload() {
        guard let delegate = delegate as? AppDelegate, let window = delegate.window else { return }
        delegate.animateReload(for: window)
    }
    
    func restart() {
        guard let delegate = delegate as? AppDelegate else { return }
        delegate.restart()
    }
}

/// maybe there is any good way to reload only one controller
/// need to try do with dismiss/present animated: false
//DispatchQueue.main.async {
//
//    self.view.setNeedsDisplay()
//    self.navigationItem.lzTitle = "hello".localized
//
//    let parant = self.view.superview!
//    let rect = self.view.frame
//    let newView = self.storyboard!.instantiateViewController(withIdentifier: "ViewController").view!
//    newView.frame = rect
//    parant.addSubview(newView)
//    self.view.removeFromSuperview()
//
//
//}
