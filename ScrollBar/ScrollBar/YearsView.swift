//
//  YearsView.swift
//  ScrollBar
//
//  Created by Bondar Yaroslav on 10/4/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class YearsView: UIView {
    
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
        autoresizingMask = [.flexibleHeight]
        backgroundColor = UIColor.lightGray
    }
    
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
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new], context: nil)
        scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: [.new], context: nil)
    }
    
    private func restore(scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }
        scrollView.showsVerticalScrollIndicator = true
        scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
        scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
    }
    
    deinit {
        restore(scrollView: scrollView)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let scrollView = scrollView else {
            return
        }
        
//        isDisabled = scrollView.contentSize.height < scrollView.frame.height
//        isHidden = isDisabled
//        
//        if isDisabled {
//            return
//        }
        
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
    
//    weak var view: UIView!
    
    private var labels = [UILabel]()
    var labelsOffesRation: [CGFloat] = [0]
    
    func update(by dates: [Date]) {
        
        var years: [Int: (months: Set<Int>, lines: Int)] = [:]
        
        for item in dates {
            
            let componets = Calendar.current.dateComponents([.year, .month], from: item)
            
            guard let year = componets.year, let month = componets.month else {
                assertionFailure()
                return
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
        
        
        print("allItems count:", dates.count)
        print(yearsArray)
        print()
        
        
        
        
        
        
        if yearsArray.isEmpty {
            assertionFailure()
            return
        }
        
        guard let scrollView = scrollView else {
            assertionFailure()
            return
        }
        
//        guard let view = view else {
//            assertionFailure()
//            return
//        }
        
//        var labelsOffes: [CGFloat] = [0]
        
        
        for year in yearsArray.dropLast() {
            let yearContentRatio = CGFloat(year.value.lines) / CGFloat(dates.count)
            labelsOffesRation.append(yearContentRatio)
//            let yearHeight = yearContentRatio * scrollView.frame.height
//            labelsOffes.append(yearHeight)
        }
        
        print("view.frame.height:", scrollView.frame.height)
//        print("labelsOffes:", labelsOffes)
        print()
        
        
        
        
        labels.forEach { $0.removeFromSuperview() }
        labels = []
        
        for _ in labelsOffesRation {
            let label = UILabel()
//            label.frame = CGRect(x: 0, y: offet, width: 50, height: 30)
            label.backgroundColor = .red
            
            addSubview(label)
            labels.append(label)
        }
        
        //        labels.forEach { addSubview($0) }
    }
    
//    func add(to view: UIView) {
//        self.view = view
//        updateFrame(by: view.frame)
//        view.addSubview(self)
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for (label, offsetRatio) in zip(labels, labelsOffesRation) {
            let offet = offsetRatio * frame.height
            label.frame = CGRect(x: 0, y: offet, width: 50, height: 30)
        }
    }
    
    let width: CGFloat = 100
    func updateFrame(by newFrame: CGRect) {
        frame = CGRect(x: newFrame.width - width, y: 0, width: width, height: newFrame.height)
    }
}
