//
//  ActivityIndicatorCounterController.swift
//  ActivityIndicator
//
//  Created by Bondar Yaroslav on 3/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol ActivityIndicatorCounterController: class {
    var activityIndicatorCounter: ActivityIndicatorCounter { get }
    func showIndicator()
    func hideIndicator()
}
