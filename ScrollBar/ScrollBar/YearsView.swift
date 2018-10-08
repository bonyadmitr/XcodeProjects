//
//  YearsView.swift
//  ScrollBar
//
//  Created by Bondar Yaroslav on 10/4/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class YearsView: UIView {
    //typealias YearsArray = [(key: Int, value: (months: Set<Int>, lines: Int))]
    
    typealias YearsArray = [(key: Int, value: (monthNumber: Int, lines: Int))]
    
    private weak var scrollView: UIScrollView?
    
    
    private let handleViewCenterY: CGFloat = 32
    private let handleViewCenterY2: CGFloat = 64
    private var firstOffest: CGFloat = 1
    
    
    private var labels = [UILabel]()
    private var labelsOffsetRatio: [CGFloat] = []
    private let selfWidth: CGFloat = 100
    
    
    private var cellHeight: CGFloat = 1
    private var headerHeight: CGFloat = 1
    private var cellSpaceHeight: CGFloat = 1
    private var numberOfColumns = 1
    //    private var cellHeaderRatio: CGFloat = 1
    //    private var cellSpaceRatio: CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        //autoresizingMask = [.flexibleHeight]
        //backgroundColor = UIColor.lightGray
    }
    
    // MARK: - UIScrollView
    
    func add(to scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            return
        }
        
        restore(scrollView: self.scrollView)
        self.scrollView = scrollView
        config(scrollView: scrollView)
        scrollView.addSubview(self)
        layoutInScrollView()
    }
    
    private func config(scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }
        
        scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new], context: nil)
        scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: [.new], context: nil)
    }
    
    private func restore(scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }
        scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
        scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
    }
    
    deinit {
        restore(scrollView: scrollView)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        layoutInScrollView()
        setNeedsLayout()
    }
    
    private func layoutInScrollView() {
        guard let scrollView = scrollView else {
            return
        }
        
        frame = CGRect(x: scrollView.frame.width - selfWidth,
                       y: scrollView.contentOffset.y,
                       width: selfWidth,
                       height: scrollView.frame.height)
    }
    
    
    private let lock = NSLock()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lock.lock()
        defer { lock.unlock() }
        
        //        guard let scrollView = scrollView else {
        //            assertionFailure()
        //            return
        //        }
        //        
        //        let contentInset: UIEdgeInsets
        //        if #available(iOS 11.0, *) {
        //            contentInset = scrollView.safeAreaInsets
        //        } else {
        //            contentInset = scrollView.contentInset
        //        }
        //        
        //        let contentOffset = scrollView.contentOffset
        //        let contentSize = scrollView.contentSize
        //        
        //        let scrollableHeight = contentSize.height + contentInset.top + contentInset.bottom - scrollView.frame.height
        //        let scrollProgress = (contentOffset.y + contentInset.top) / scrollableHeight
        //        //        handleFrame.origin.y = scrollProgress * (frame.height - handleFrame.height)
        //        
        //        let q = scrollView.frame.height / scrollableHeight
        
        var lastLabelOffset: CGFloat = 0
        
        for (label, offsetRatio) in zip(labels, labelsOffsetRatio) {
            let offet: CGFloat
            if offsetRatio == 0 {
                offet = handleViewCenterY - label.frame.height * 0.5
            } else {
                offet = offsetRatio * 0.98 * (frame.height - handleViewCenterY) + label.frame.height * 0.5
            }
            
            if lastLabelOffset > offet {
                label.isHidden = true
                continue
            }
            label.isHidden = false
            
            label.frame = CGRect(x: 0, y: offet, width: label.frame.width, height: label.frame.height)
            lastLabelOffset = offet + label.frame.height
            
            //            let offet = offsetRatio * (frame.height - handleViewCenterY2) + label.frame.height * 0.5
            //            label.frame = CGRect(x: 0, y: offet, width: label.frame.width, height: label.frame.height)
            
        }
    }
    
    // MARK: - Dates
    
    func update(by dates: [Date]) {
        if dates.isEmpty {
            return
        }
        
        let yearsArray = getYearsArray(from: dates)
        
        let newYearsArray = updateLabelsOffsetRatio(from: yearsArray, dates: dates)
        udpateLabels(from: newYearsArray)
    }
    
    func update(cellHeight: CGFloat, headerHeight: CGFloat, numberOfColumns: Int) {
        self.cellHeight = cellHeight
        self.headerHeight = headerHeight
        self.numberOfColumns = numberOfColumns
        
        //        cellHeaderRatio = headerHeight / cellHeight
        //        cellSpaceRatio = 1 / cellHeight
    }
    
    private var sectionsWithCount: [(name: String, count: Int)] = []
    
    func update(sectionsWithCount: [(name: String, count: Int)]) {
        self.sectionsWithCount = sectionsWithCount
    }
    
    
    private func getYearsArray(from dates: [Date]) -> YearsArray {
        
        //        var years: [Int: (months: Set<Int>, lines: Int)] = [:]
        var years: [Int: [Int: Int]] = [:]
        
        for item in dates {
            
            let componets = Calendar.current.dateComponents([.year, .month], from: item)
            
            guard let year = componets.year, let month = componets.month else {
                assertionFailure()
                return []
            }
            
            //            if years[year] == nil {
            //                years[year] = (Set([month]), 1)
            //            } else {
            //                years[year]!.lines += 1
            //                years[year]!.months.insert(month)
            //            }
            
            if years[year] == nil {
                years[year] = [month: 1]
            } else {
                if years[year]![month] == nil {
                    years[year]![month] = 1 
                } else {
                    years[year]![month]! += 1
                }
            }
        }
        
        
        //        let yearsArray = years.sorted { year1, year2 in
        //            year1.key < year2.key
        //        }
        
        var yearLines: [Int: (monthNumber: Int, lines: Int)] = [:]
        
        years.forEach { yearArg in
            let (year, month) = yearArg
            let monthLines = month.reduce(0, { sum, arg in
                let addtionalLine = (arg.value % numberOfColumns == 0) ? 0 : 1 
                return sum + arg.value / numberOfColumns + addtionalLine
            })
            
            
            
            yearLines[year, default: (0, 0)].lines += monthLines
            yearLines[year, default: (0, 0)].monthNumber += month.keys.count
        }
        
        let yearsArray = yearLines.sorted { year1, year2 in
            year1.key > year2.key
        }
        
        return yearsArray
    }
    
    private func updateLabelsOffsetRatio(from yearsArray: YearsArray, dates: [Date]) -> YearsArray {        
        //        var yearLines: [Int: Int] = [:]
        //        
        //        yearsArray.forEach { yearArg in
        //            let (year, month) = yearArg
        //            let monthLines = month.reduce(0, { sum, arg in
        //                let addtionalLine = (arg.value % 4 == 0) ? 0 : 1 
        //                return sum + arg.value / 4 + addtionalLine
        //            })
        //            
        //            yearLines[year, default: 0] += monthLines
        //        }
        
        let totalLines = yearsArray.reduce(0) { sum, arg in
            sum + arg.value.lines
        }
        
        let totalMonthes = yearsArray.reduce(0) { sum, arg in
            sum + arg.value.monthNumber
        }
        
        let sectionsWithCountLines = sectionsWithCount.map { section -> Int in
            let addtionalLine = (section.count % numberOfColumns == 0) ? 0 : 1 
            return section.count / numberOfColumns + addtionalLine
        }
        
        let totalSectionsWithCount = sectionsWithCountLines.reduce(0) { $0 + $1 }
        
        //        let totalSpace = CGFloat(totalLines) + cellHeaderRatio * CGFloat(totalMonthes) + cellSpaceRatio * CGFloat(totalLines + totalMonthes)
        let totalSpace = CGFloat(totalLines + totalSectionsWithCount) * cellHeight + headerHeight * CGFloat(totalMonthes + sectionsWithCount.count) + cellSpaceHeight * CGFloat(totalLines + totalMonthes + sectionsWithCount.count + totalSectionsWithCount)
        
        
        //        var newYearsArray = yearsArray
        //        var numberOfDeltedItems = 0
        //        
        //        var connectNextYear = false
        //        
        //        var lastYearRatio: CGFloat = 0
        
        var previusOffsetRation: CGFloat = 0
        labelsOffsetRatio = [0]
        
        /// dropLast bcz we put 0 to labelsOffsetRatio
        for (index, year) in yearsArray.enumerated() {
            
            //            let yearHeaderRatio = (CGFloat(year.value.monthNumber) / CGFloat(totalMonthes))// * cellHeaderRatio
            
            //            let yearCellSpaceRatio = cellSpaceRatio * CGFloat(year.value.lines + year.value.monthNumber)
            //            let yearHeaderRatio = CGFloat(year.value.monthNumber) * cellHeaderRatio
            //            let linesRatio = CGFloat(year.value.lines)
            //            let yearRatio = (linesRatio + yearHeaderRatio + yearCellSpaceRatio) / totalSpace
            
            let yearCellSpaceRatio = cellSpaceHeight * CGFloat(year.value.lines + year.value.monthNumber)
            let yearHeaderRatio = CGFloat(year.value.monthNumber) * headerHeight
            let linesRatio = CGFloat(year.value.lines) * cellHeight
            let yearRatio = (linesRatio + yearHeaderRatio + yearCellSpaceRatio) / totalSpace
            
            
            //            let yearRatio = CGFloat(year.value.lines) / CGFloat(totalLines)
            
            let yearContentRatio = yearRatio + previusOffsetRation
            
            //            let yearCellSpaceRatio = cellSpaceRatio * CGFloat(year.value.lines + year.value.monthNumber)
            //            let yearHeaderRatio = CGFloat(year.value.monthNumber) * cellHeaderRatio
            //            let yearRatio = yearHeaderRatio + yearCellSpaceRatio + CGFloat(year.value.lines)
            //            let yearContentRatio = yearRatio / CGFloat(totalLines) + previusOffsetRation
            
            //            if connectNextYear {
            //                connectNextYear = false
            //                
            //                if !labelsOffsetRatio.isEmpty {
            //                    labelsOffsetRatio[labelsOffsetRatio.count - 1] += yearContentRatio - previusOffsetRation
            //                    let indexToDelete = index - numberOfDeltedItems
            //                    newYearsArray.remove(at: indexToDelete)
            //                    numberOfDeltedItems += 1
            //                    
            //                    previusOffsetRation = labelsOffsetRatio[labelsOffsetRatio.count - 1]
            //                    
            //                    if lastYearRatio + yearRatio < 20 {
            //                        connectNextYear = true
            //                    }
            //                } else {
            //                    
            //                    
            //                    previusOffsetRation = yearContentRatio
            //                    labelsOffsetRatio.append(yearContentRatio)
            //                }
            //                
            //            } else {
            //                previusOffsetRation = yearContentRatio
            //                if yearRatio < 20 {
            //                    connectNextYear = true
            //                } else {
            //                    //                labelsOffsetRatio.append(yearContentRatio)
            //                }
            //                labelsOffsetRatio.append(yearContentRatio)
            //            }
            //            
            //            lastYearRatio = yearRatio
            
            previusOffsetRation = yearContentRatio
            labelsOffsetRatio.append(yearContentRatio)
            
        }
        
        for sectionLinesNumber in sectionsWithCountLines.dropLast() {
            let yearCellSpaceRatio = cellSpaceHeight * CGFloat(sectionLinesNumber + 1)
            let yearHeaderRatio = 1 * headerHeight
            let linesRatio = CGFloat(sectionLinesNumber) * cellHeight
            let yearRatio = (linesRatio + yearHeaderRatio + yearCellSpaceRatio) / totalSpace
            
            let yearContentRatio = yearRatio + previusOffsetRation
            
            previusOffsetRation = yearContentRatio
            labelsOffsetRatio.append(yearContentRatio)
        } 
        
        //        return newYearsArray
        return yearsArray
    }
    
    private func udpateLabels(from yearsArray: YearsArray) {
        DispatchQueue.main.async {
            self.lock.lock()
            defer { self.lock.unlock() }
            
            self.labels.forEach { $0.removeFromSuperview() }
            self.labels.removeAll()
            
            for year in yearsArray {
                let label = self.createLabel(for: "\(year.key)")
                self.addSubview(label)
                self.labels.append(label)
            }
            
            for section in self.sectionsWithCount {
                let label = self.createLabel(for: section.name)
                self.addSubview(label)
                self.labels.append(label)
            }
        }
        
    }
    
    private func createLabel(for text: String) -> UILabel {
        let label = TextInsetsLabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 8)
//        label.font = UIFont.TurkcellSaturaDemFont(size: 8)
        label.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        label.textColor = .red
//        label.textColor = UIColor.lrTealishTwo
        label.textInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        label.sizeToFit()
        label.layer.cornerRadius = label.frame.height * 0.5
        label.layer.masksToBounds = true
        return label
    }
}
