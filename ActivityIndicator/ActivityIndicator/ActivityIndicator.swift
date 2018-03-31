//
//  ActivityIndicator.swift
//  ActivityIndicator
//
//  Created by Bondar Yaroslav on 3/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol ActivityIndicator {
    var activityView: UIView { get }
    func start()
    func stop()
}
extension ActivityIndicator where Self: UIView {
    var activityView: UIView {
        return self
    }
}
