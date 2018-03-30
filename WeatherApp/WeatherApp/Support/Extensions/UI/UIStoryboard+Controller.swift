//
//  UIStoryboardExtentions.swift
//  SwiftBest
//
//  Created by zdaecqze zdaecq on 11.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func instantiate<T>(_ identifier: T.Type) -> T {
        let identifierString = String(describing: identifier)
        return instantiateViewController(withIdentifier: identifierString) as! T
    }
}
