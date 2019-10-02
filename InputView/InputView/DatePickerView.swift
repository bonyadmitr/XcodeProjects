import UIKit

final class DatePickerView: InputView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addTapGestureToOpenInputView()
        set(inputView: datePicker, inputAccessoryView: toolBar)
    }
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.isTranslucent = false
        
        /// background color
        toolBar.barTintColor = .systemTeal
        
        /// buttons color
        toolBar.tintColor = .white
        
        /// to fix breaking constraints
        toolBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 44)
        
        toolBar.items = [.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                         .init(title: "Done", style: .plain, target: self, action: #selector(endEditing(_:)))]
        
        /// update toolBar.frame.height to system one. defalut 44
        toolBar.sizeToFit()
        
        return toolBar
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        /// can be set
        datePicker.frame.size.height = 300
        
        datePicker.backgroundColor = .systemTeal
        
        /// UIDatePicker text color https://stackoverflow.com/a/35493387/5893286
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.sendAction(Selector(("setHighlightsToday:")), to: nil, for: nil)
        
        return datePicker
    }()
}
