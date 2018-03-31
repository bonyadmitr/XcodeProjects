//
//  Fonts.swift
//  FontSelect
//
//  Created by zdaecqze zdaecq on 29.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

public struct Fonts {
    public static let familyNames = UIFont.familyNames.sorted()
    public static let fonts = familyNames.map { UIFont.fontNames(forFamilyName: $0).sorted() }
}
