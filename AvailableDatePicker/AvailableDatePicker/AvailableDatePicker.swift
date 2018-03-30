//
//  AvailableDatePicker.swift
//  AvailableDatePicker
//
//  Created by Bondar Yaroslav on 02/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class AvailableDatePicker: UIPickerView {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInit()
    }
    private func setupInit() {
        dataSource = self
        delegate = self
    }
    
    // MARK: - Dates
    
    // TODO: maybe create with timer or delete
    var didSelectDate: (Date)->Void = {_ in}
    
    var selectedDate: Date? {
        
        print(selectedYear, selectedMonth, selectedDay)
        
        guard let yearClass = yearClasses[safe: selectedYear],
            let monthClass = yearClass.months[safe: selectedMonth],
            let day = monthClass.days[safe: selectedDay],
            let date = DateComponents(calendar: .current, timeZone: timeZone, year: yearClass.year, month: monthClass.month, day: day, hour: 0, minute: 0, second: 0).date
            else { return nil }
        
        return date
    }
    
    // MARK: - Dates setup
    
    /// dates will be sorted automaticaly
    var dates: [Date] = [] {
        didSet { yearClasses = convertDatesToYearClasses(dates) }
    }
    var startDate: Date? {
        didSet { setup() }
    }
    fileprivate var yearClasses: [YearClass] = [] {
        didSet { setup() }
    }
    private func setup() {
        reloadAllComponents()
        selectStartDate()
    }
    
    private func selectStartDate() {
        guard let date = startDate else { return }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        guard let yi = yearClasses.index(where: {$0.year == year}),
            let mi = yearClasses[yi].months.index(where: {$0.month == month}),
            let di = yearClasses[yi].months[mi].days.index(where: {$0 == day})
            else { return }
        
        selectRow(yi, inComponent: DateComponent.year.rawValue, animated: false)
        selectRow(mi, inComponent: DateComponent.month.rawValue, animated: false)
        selectRow(di, inComponent: DateComponent.day.rawValue, animated: false)
    }
    
    // MARK: - Helpers
    
    var selectedYear: Int {
        return selectedRow(inComponent: 0)
    }
    var selectedMonth: Int {
        return selectedRow(inComponent: 1)
    }
    var selectedDay: Int {
        return selectedRow(inComponent: 2)
    }
    
    // MARK: - Customization
    
    /// timeZone for return date
    var timeZone: TimeZone? = TimeZone(abbreviation: "GMT")
    
    /// default color is UILabel default
    var textColor: UIColor?
    
    /// default font is default for UIPickerView
    var textFont: UIFont = UIFont.systemFont(ofSize: 21)
    
    /// inset between rows
    var rowInset: CGFloat = 0
    
    /// if you need more customization than color and font
    var customLabel: UILabel?
}




// MARK: - UIPickerViewDataSource

extension AvailableDatePicker: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return textFont.lineHeight + rowInset
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch DateComponent(rawValue: component)! {
        case .year:
            return yearClasses.count
            
        case .month:
            guard let yearClass = yearClasses[safe: selectedYear] else { return 0 }
            return yearClass.months.count
            
        case .day:
            guard
                let yearClass = yearClasses[safe: selectedYear],
                let monthClass = yearClass.months[safe: selectedMonth]
                else { return 0 }
            return monthClass.days.count
        }
    }
}




// MARK: - UIPickerViewDelegate

extension AvailableDatePicker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
        if let date = selectedDate {
            didSelectDate(date)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = getLabel(for: view)
        label.text = getTitle(for: row, in: component)
        return label
    }
    
    // MARK: - Helpers
    
    private func getTitle(for row: Int, in component: Int) -> String {
        var title = ""
        
        switch DateComponent(rawValue: component)! {
        case .year:
            if let year = yearClasses[safe: row]?.year {
                title = String(year)
            }
            
        case .month:
            if let yearClass = yearClasses[safe: selectedYear], let monthClass = yearClass.months[safe: row] {
                title = monthClass.monthName
            }
            
        case .day:
            if let yearClass = yearClasses[safe: selectedYear],
                let monthClass = yearClass.months[safe: selectedMonth],
                let day = monthClass.days[safe: row] {
                title = String(day)
            }
        }
        return title
    }
    
    private func getLabel(for reuseView: UIView?) -> UILabel {
        if let label = reuseView as? UILabel {
            return label
        }
        else if let label = customLabel {
            return label
        }
        else {
            let label = UILabel()
            label.textAlignment = .center
            label.font = textFont
            label.textColor = textColor
            return label
        }
    }
}

// MARK: - fileprivate

fileprivate func convertDatesToYearClasses(_ dates: [Date]) -> [YearClass] {
    let calendar = Calendar.current
    var yearClasses: [YearClass] = []
    let dates = dates.sorted()
    
    for date in dates {
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        /// year check
        if let yearClass = yearClasses.filter({ $0.year == year }).last {
            
            /// month check
            if let monthClasses = yearClass.months.filter({ $0.month == month }).last {
                
                /// day check
                if !monthClasses.days.contains(day) {
                    monthClasses.days.append(day)
                }
                
            } else {
                let newMonth = MonthClass(month: month, day: day)
                yearClass.months.append(newMonth)
            }
            
        } else {
            let newMonth = MonthClass(month: month, day: day)
            let newYear = YearClass(year: year, month: newMonth)
            yearClasses += [newYear]
        }
    }
    return yearClasses
}
