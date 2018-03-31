//
//  SomeSiwzzable.swift
//  SwizzlingSwift
//
//  Created by Bondar Yaroslav on 21/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// https://habrahabr.ru/post/274545/
/// он должен быть наследником NSObject
/// подменяемый метод должен иметь атрибут dynamic
class SomeSiwzzable: NSObject {
    dynamic func printSome() {
        print("printSome")
    }
}
