//
//  ResponseResult.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 11/10/17.
//  Copyright © 2017 LifeTech. All rights reserved.
//

import Foundation

enum ResponseResult <T> {
    case success(T)
    case failed(Error)
}
