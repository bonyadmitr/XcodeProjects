//
//  PickerTextField.swift
//  PickerView
//
//  Created by Bondar Yaroslav on 4/3/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// picker view customization
/// https://github.com/cybertk/CKPickerView

///typealias VoidHandler = () -> Void
typealias PickerComponent = String
typealias PickerHandler = (_ component: PickerComponent, _ index: Int) -> Void

final class PickerTextField: UITextField {
    
    private let pickerView = UIPickerView()
    
    var components: [PickerComponent] = [] {
        didSet {
            pickerView.reloadAllComponents()
            //            text = currentComponent
        }
    }
    
    var didSelectRow: PickerHandler?
    
    /// returns selected row. -1 if nothing selected
    var currentIndex: Int {
        return pickerView.selectedRow(inComponent: 0)
    }
    
    /// CHECK FOR OUT OF RANGE
    var currentComponent: PickerComponent? {
        if currentIndex > components.count || currentIndex < 0 {
            return nil
        }
        return components[currentIndex]
    }
    
    private let doneToolBar = DoneToolBar()
    
    var doneButtonTitle: String? {
        didSet {
            doneToolBar.doneButtonTitle = doneButtonTitle
        }
    }
    
    var doneAction: PickerHandler? {
        didSet {
            doneToolBar.doneAction = { [weak self] in
                guard let `self` = self, let currentComponent = self.currentComponent else {
                    return
                }
                self.doneAction?(currentComponent, self.currentIndex)
            } 
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.showsSelectionIndicator = true ///?
        inputView = pickerView
        inputAccessoryView = doneToolBar
    }
}
extension PickerTextField: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return components.count
    }
}
extension PickerTextField: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return components[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = components[row]
//        text = item
        didSelectRow?(item, row)
    }
}
