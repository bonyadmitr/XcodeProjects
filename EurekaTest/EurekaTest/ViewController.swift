//
//  ViewController.swift
//  EurekaTest
//
//  Created by Bondar Yaroslav on 20/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Eureka

class ViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enables the navigation accessory and stops navigation when a disabled row is encountered
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        // Enables smooth scrolling on navigation to off-screen rows
        animateScroll = true
        // Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
        rowKeyboardSpacing = 20
        
        form
        +++ Section("Section1")
            
            <<< TextRow() {
                $0.title = "Text Row"
                $0.placeholder = "Enter text here"
            }.onChange {_ in
               print("onChange")
            }.onCellSelection({ (_, _) in
                print("onCellSelection")
            }).onCellHighlightChanged({ (_, _) in
                print("onCellHighlightChanged")
            }).onRowValidationChanged({ (_, _) in
                print("onRowValidationChanged")
            })
            
            <<< PhoneRow() {
                $0.title = "Phone Row"
                $0.placeholder = "And numbers here"
            }
            
            <<< PushRow<String>() {
                $0.title = "PushRow"
                $0.options = ["1", "2", "3", "4"]
                $0.value = "2"
                $0.selectorTitle = "Choose an Emoji!"
            }.onChange {
                print($0.value!)
            }
            
        +++ Section("Section2")
            <<< DateRow() {
                $0.title = "Date Row"
//                $0.value = Date(timeIntervalSinceReferenceDate: 0)
        }
        +++ SelectableSection<ListCheckRow<String>>("Where do you live",
                                                    selectionType: .singleSelection(enableDeselection: true))
        
            let continents = ["Africa", "Antarctica", "Asia", "Australia", "Europe", "North America", "South America"]
            for option in continents {
                form.last! <<< ListCheckRow<String>(option){ listRow in
                    listRow.title = option
                    listRow.selectableValue = option
//                    listRow.value = nil
                }
        }
        
        
    }
}

