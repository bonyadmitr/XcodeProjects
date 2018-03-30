//
//  Strongify.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 02/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// https://github.com/krzysztofzablocki/Strongify
func strongify<Context1: AnyObject, Argument1>(weak context1: Context1?, closure: @escaping(Context1, Argument1) -> Void) -> (Argument1) -> Void {
    return { [weak context1] argument1 in
        guard let strongContext1 = context1 else { return }
        closure(strongContext1, argument1)
    }
}
