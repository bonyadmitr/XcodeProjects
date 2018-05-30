//
//  Protocols.swift
//  SwiftMapRequest
//
//  Created by Rustam N on 24.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import UIKit

protocol Controller {
    static func doGetRequest(_ urlWithParameters : URL, viewController: UIViewController?, whenComplete : DataTaskDelegate)
}

protocol DataTaskDelegate {
    func getResponce(_ result : Data?)
}
