//
//  YearsSectionIndex.swift
//  ScrollBar
//
//  Created by Bondar Yaroslav on 10/8/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

let scrollBarHandleMinHeightGlobal: CGFloat = 36

final class YearsSectionIndex: UIView {
    
    typealias YearsArray = [(key: Int, value: (monthNumber: Int, lines: Int))]
    
    var numberOfColumns = 4
    var labelsOffsetRatio: [CGFloat] = []
    
    var cellHeight: CGFloat = 102
    var headerHeight: CGFloat = 44
    let cellSpaceHeight: CGFloat = 1//.167
    let scrollInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    private weak var scrollView: UIScrollView?
    private var lastContentHeight: CGFloat = 0
    
    func observe(scrollView: UIScrollView) {
        restore(scrollView: self.scrollView)
        self.scrollView = scrollView
        config(scrollView: scrollView)
    }
    
    private func config(scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }
        
        //        scrollView.showsVerticalScrollIndicator = false
        scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new], context: nil)
        scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: [.new], context: nil)
    }
    
    private func restore(scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }
        //        scrollView.showsVerticalScrollIndicator = true
        scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
        scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
    }
    
    deinit {
        restore(scrollView: scrollView)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let scrollView = scrollView else {
            assertionFailure()
            return
        }
        
        if keyPath == #keyPath(UIScrollView.contentSize), lastContentHeight != scrollView.contentSize.height {
            lastContentHeight = scrollView.contentSize.height
            updateHeightOffset()
            setNeedsLayout()
        }
    }
    
    private var scrollableHeight: CGFloat = 1
    private let scrollBarHandleMinHeight: CGFloat = scrollBarHandleMinHeightGlobal
    
    private func updateHeightOffset() {
        guard let scrollView = scrollView, scrollView.contentSize.height > 0 else {
            return
        }
        
        let contentInset = scrollView.contentInset
        
        scrollableHeight = scrollView.contentSize.height - scrollView.frame.height + contentInset.top + contentInset.bottom
//        let scrollProgress = (scrollView.contentOffset.y + contentInset.top) / scrollableHeight
//        var handleOffset = scrollProgress * (frame.height - 30)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lock.lock()
        defer { lock.unlock() }
        
        var lastLabelOffset: CGFloat = 0
        
        guard let scrollView = scrollView, scrollView.contentSize.height > 0 else {
            return
        }
        
        let contentInset = scrollView.contentInset
        let scrollableHeight = scrollView.contentSize.height + contentInset.top + contentInset.bottom
//        let scrollProgress = (scrollView.contentOffset.y + contentInset.top) / scrollableHeight
//        var handleOffset = scrollProgress * (frame.height - scrollBarHandleMinHeight)
        
        let heightRatio = scrollView.frame.height / scrollView.contentSize.height
        //let defaultBarHeight = max(floor(frame.height * heightRatio), scrollBarHandleMinHeight)
        let defaultBarHeight = scrollView.frame.height * heightRatio
        print(defaultBarHeight)
        
//        let q = (height - scrollBarHandleMinHeight) / scrollableHeight
//        let q = scrollBarHandleMinHeight / defaultBarHeight
//        print(q)
//        
//        let w = (defaultBarHeight - scrollBarHandleMinHeight) * q
//        print(w)
        
//        let totalOffset = labelsOffsetRatio.reduce(0, { $0 + $1})
        
        let userOffset = cellHeight + headerHeight + cellSpaceHeight * 2
        let userLabelOffset = (userOffset / (scrollView.contentSize.height - scrollView.frame.height)) * (scrollView.frame.height - scrollBarHandleMinHeight)
        
        
//        print("1:", scrollView.contentSize.height - scrollView.frame.height)
//        print("2:", scrollView.frame.height - scrollBarHandleMinHeight)
//        print("3:", (1 / (scrollView.contentSize.height - scrollView.frame.height)) * (scrollView.frame.height - scrollBarHandleMinHeight))
        
        for (label, offsetRatio) in zip(labels, labelsOffsetRatio) {
            
            
            let offset: CGFloat
            if offsetRatio == 0 {
                offset = 0
            } else if defaultBarHeight < scrollBarHandleMinHeight {
                offset = offsetRatio * frame.height + (1 - offsetRatio) * (scrollBarHandleMinHeight - defaultBarHeight) 
            } else {
                
//                let q: CGFloat = offsetRatio * scrollView.contentSize.height
//                let w = (q / (scrollView.contentSize.height - scrollView.frame.height)) * (scrollView.frame.height - scrollBarHandleMinHeight)
                
                offset = (offsetRatio) * (frame.height) - (1 - offsetRatio) * (defaultBarHeight - scrollBarHandleMinHeight + (defaultBarHeight - scrollBarHandleMinHeight) / 7)// - scrollBarHandleMinHeight / defaultBarHeight * scrollBarHandleMinHeight * (1 - offsetRatio)
            }
            
            
            
//            let scrollableHeight = scrollView.contentSize.height - scrollView.frame.height + contentInset.top + contentInset.bottom
//            let scrollProgress = (scrollView.contentOffset.y + contentInset.top) / scrollableHeight
//            var handleOffset = scrollProgress * (frame.height - handleView.frame.height)
            
            
            
//            let offset = max(0, (offsetRatio - q)) * frame.height
//            let offset = (offsetRatio) * (frame.height)// + (defaultBarHeight - 3) * (1 - offsetRatio)// + userLabelOffset
            
            
            print("offsetRatio:", offsetRatio)
            print("offet:", offset)
            
//            if lastLabelOffset > offet {
//                label.isHidden = true
//                continue
//            }
//            label.isHidden = false
            
            label.frame = CGRect(x: 40, y: offset, width: label.frame.width, height: label.frame.height)
            lastLabelOffset = offset + label.frame.height
            
        }
    }
    
    func update(by dates: [Date]) {
        if dates.isEmpty {
            return
        }
        
        let yearsArray = getYearsArray(from: dates)  
        updateLabelsOffsetRatio(from: yearsArray, dates: dates)
        udpateLabels(from: yearsArray)
    }
    
    private func getYearsArray(from dates: [Date]) -> YearsArray {
        var years: [Int: [Int: Int]] = [:]
        
        for item in dates {
            let componets = Calendar.current.dateComponents([.year, .month], from: item)
            
            guard let year = componets.year, let month = componets.month else {
                assertionFailure()
                return []
            }
            
            if years[year] == nil {
                years[year] = [month: 1]
            } else if years[year]![month] == nil {
                years[year]![month] = 1 
            } else {
                years[year]![month]! += 1
            }
        }
        
        var yearLines: [Int: (monthNumber: Int, lines: Int)] = [:]
        
        years.forEach { yearArg in
            let (year, month) = yearArg
            
            let monthLines = month.reduce(0, { sum, arg in
                let addtionalLine = (arg.value % numberOfColumns == 0) ? 0 : 1 
                return sum + arg.value / numberOfColumns + addtionalLine
            })
            
            
            if yearLines[year] == nil {
                yearLines[year] = (month.keys.count, monthLines)
            } else {
                yearLines[year]!.monthNumber += month.keys.count
                yearLines[year]!.lines += monthLines
            }
        }
        
        let yearsArray = yearLines.sorted { year1, year2 in
            year1.key > year2.key
        }
        
        return yearsArray
    }
    
    private func updateLabelsOffsetRatio(from yearsArray: YearsArray, dates: [Date]) {        
        
        let totalLines = yearsArray.reduce(0) { sum, arg in
            sum + arg.value.lines
        }
        
        let totalMonthes = yearsArray.reduce(0) { sum, arg in
            sum + arg.value.monthNumber
        }
        
        let totalSpace = CGFloat(totalLines) * cellHeight +
                        headerHeight * CGFloat(totalMonthes) +
                        cellSpaceHeight * CGFloat(totalLines + totalMonthes) +
                        scrollInsets.top + scrollInsets.bottom
        
        var previusOffsetRation: CGFloat = 0
        labelsOffsetRatio = [0]
        
        /// dropLast bcz we put 0 to labelsOffsetRatio
        for year in yearsArray.dropLast() {
            
            let yearCellSpaceRatio = cellSpaceHeight * CGFloat(year.value.lines + year.value.monthNumber)
            let yearHeaderRatio = CGFloat(year.value.monthNumber) * headerHeight
            let linesRatio = CGFloat(year.value.lines) * cellHeight
            
            let yearRatio: CGFloat
            if year.key == yearsArray.first?.key {
                yearRatio = (linesRatio + yearHeaderRatio + yearCellSpaceRatio + scrollInsets.top) / totalSpace
            } else {
                yearRatio = (linesRatio + yearHeaderRatio + yearCellSpaceRatio) / totalSpace
            }
            
            // FIXME: if new section will be added. remove "dropLast()" and "year.key == last?.key"
            
            let yearContentRatio = yearRatio + previusOffsetRation

            
            previusOffsetRation = yearContentRatio
            labelsOffsetRatio.append(yearContentRatio)
        }
    }
    
    let lock = NSLock()
    var labels: [UILabel] = []
    
    private func udpateLabels(from yearsArray: YearsArray) {
        DispatchQueue.main.async {
            self.lock.lock()
            defer { self.lock.unlock() }
            
            // TODO: optimize
            self.labels.forEach { $0.removeFromSuperview() }
            self.labels.removeAll()
            
            for year in yearsArray {
                let label = self.createLabel(for: "\(year.key)")
                self.addSubview(label)
                self.labels.append(label)
            }
        }
        
    }
    
    private func createLabel(for text: String) -> UILabel {
        let label = TextInsetsLabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = UIColor.black//.withAlphaComponent(0.7)
        label.textColor = .red
        label.textInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        label.sizeToFit()
//        label.layer.cornerRadius = label.frame.height * 0.5
        label.layer.masksToBounds = true
        return label
    }
}
