//
//  ConfigurationBlockHolder.swift
//  ViperKit
//
//  Created by Bondar Yaroslav on 27/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

final internal class ConfigurationBlockHolder {
    typealias ConfigurationHandler = (ModuleInput) -> Void
    
    let block: ConfigurationHandler
    
    init(block: @escaping ConfigurationHandler) {
        self.block = block
    }
}
