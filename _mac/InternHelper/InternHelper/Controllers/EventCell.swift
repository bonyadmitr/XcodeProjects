//
//  EventCell.swift
//  InternHelper
//
//  Created by Yaroslav Bondar on 05.07.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import Cocoa

// TODO: разобраться с ячейками таблицы их кастомизацией
// TODO: возможно для этого на много лучше подойдет коллекция, а не таблица
// TODO: (сказывается не хватка опыта разработка под мак)
class EventCell: NSCell {
    
    @IBOutlet weak var nameField: NSTextField!
}



class EventCell2: NSTableCellView {
    
    @IBOutlet weak var nameField: NSTextField!
}
