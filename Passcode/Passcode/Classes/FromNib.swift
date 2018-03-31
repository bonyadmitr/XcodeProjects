//
//  FromNib.swift
//  Passcode
//
//  Created by Bondar Yaroslav on 10/2/17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol FromNib: class {
//    func setupFromNib<T : UIView>() -> T!
    
}

extension UIView {
//    @discardableResult   // 1
//    func setupFromNib<T : UIView>() -> T! {   // 2
//        guard let contentView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {    // 3
//            return nil
//        }
//        self.addSubview(contentView)     // 4
//        contentView.frame = bounds
//        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        return contentView   // 7
//    }
    func setupFromNib() {
        let view = loadFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }

    private func loadFromNib() -> UIView {
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}

