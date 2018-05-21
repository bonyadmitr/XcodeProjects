//
//  UIScrollView+Offest.swift
//  PullToRefreshTest
//
//  Created by Bondar Yaroslav on 15/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIScrollView {
    func setStatusBarOffset() {
        let top = UIApplication.shared.statusBarFrame.size.height
        contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
    }
}
