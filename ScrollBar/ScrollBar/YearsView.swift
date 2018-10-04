//
//  YearsView.swift
//  ScrollBar
//
//  Created by Bondar Yaroslav on 10/4/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class YearsView: UIView {
    
    typealias YearsArray = [(key: Int, value: (months: Set<Int>, lines: Int))]
    
    private weak var scrollView: UIScrollView?
    
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
        
        frame = CGRect(x: scrollView.frame.width - width,
                       y: scrollView.contentOffset.y,
                       width: width,
                       height: scrollView.frame.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for (label, offsetRatio) in zip(labels, labelsOffsetRatio) {
            let offet = offsetRatio * frame.height
            label.frame = CGRect(x: 0, y: offet, width: label.frame.width, height: label.frame.height)
        }
    }
    
    // MARK: - Dates
    
    private var labels = [UILabel]()
    private var labelsOffsetRatio: [CGFloat] = []
    private let width: CGFloat = 100
    
    func update(by dates: [Date]) {
        
        let yearsArray = getYearsArray(from: dates)
        
        if yearsArray.isEmpty {
            assertionFailure()
            return
        }
        
        updateLabelsOffsetRatio(from: yearsArray, dates: dates)
        udpateLabels(from: yearsArray)
    }
    
    private func getYearsArray(from dates: [Date]) -> YearsArray {
        
        var years: [Int: (months: Set<Int>, lines: Int)] = [:]
        
        for item in dates {
            
            let componets = Calendar.current.dateComponents([.year, .month], from: item)
            
            guard let year = componets.year, let month = componets.month else {
                assertionFailure()
                return []
            }
            
            if years[year] == nil {
                years[year] = (Set([month]), 1)
            } else {
                years[year]!.lines += 1
                years[year]!.months.insert(month)
            }
        }
        
        let yearsArray = years.sorted { year1, year2 in
            year1.key < year2.key
        }
        return yearsArray
    }
    
    private func updateLabelsOffsetRatio(from yearsArray: YearsArray, dates: [Date]) {
        labelsOffsetRatio = [0]
        var previusOffsetRation: CGFloat = 0
        for year in yearsArray.dropLast() {
            let yearContentRatio = CGFloat(year.value.lines) / CGFloat(dates.count) + previusOffsetRation
            previusOffsetRation = yearContentRatio
            labelsOffsetRatio.append(yearContentRatio)
        }
    }
    
    private func udpateLabels(from yearsArray: YearsArray) {
        labels.forEach { $0.removeFromSuperview() }
        labels.removeAll()
        
        for year in yearsArray {
            let label = TextInsetsLabel()
            label.text = "\(year.key)"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 8) //UIFont.TurkcellSaturaDemFont(size: 8)
            label.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            label.textColor = .red
            label.textInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
            label.sizeToFit()
            label.layer.cornerRadius = label.frame.height * 0.5
            label.layer.masksToBounds = true
            
            addSubview(label)
            labels.append(label)
        }
    }
}
