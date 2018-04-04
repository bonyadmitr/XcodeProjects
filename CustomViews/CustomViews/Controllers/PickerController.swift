//
//  PickerController.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 4/4/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

typealias VoidHandler = () -> Void

final class PickerController: UIViewController {
    
    @IBOutlet weak var pickerTextField: PickerTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerTextField.components = ["qqqqqqq", "wwww", "qwe", "123", "qwe", "123", "qwe", "123", "qwe", "123"]
        pickerTextField.didSelectRow = { [weak self] component, index in
            self?.pickerTextField.text = component
            print("index: \(index), component: \(component)")
        }
        
        pickerTextField.doneButtonTitle = NSLocalizedString("Done", comment: "")
        pickerTextField.doneAction = { [weak self] component, index in
            print("done with index: \(index), component: \(component)")
            self?.pickerTextField.text = "Done " + component
            self?.pickerTextField.resignFirstResponder()
        }
    }
    
}
