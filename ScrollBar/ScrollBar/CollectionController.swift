//
//  CollectionController.swift
//  ScrollBar
//
//  Created by Bondar Yaroslav on 10/4/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class CollectionController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        willSet {
            newValue.dataSource = self
            newValue.delegate = self
            newValue.register(ImageTextColCell.self, forCellWithReuseIdentifier: "ImageTextColCell")
            newValue.register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionHeader")
            
            newValue.alwaysBounceVertical = true
            
            if let layout = newValue.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumLineSpacing = 1
                layout.minimumInteritemSpacing = 1
                layout.sectionInset = .init(top: 1, left: 1, bottom: 1, right: 1)
            }
        }
    }
    
    private let scrollBar = ScrollBarView()
    private let yearsView = YearsView()
    
    private var sections: [(key: YearMonth, value: [Date])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
        yearsView.add(to: collectionView)
        scrollBar.add(to: collectionView)
        
        let initialDate = Date()
        
        var dates = (0...10).map({ initialDate.addingTimeInterval(TimeInterval(3600 * 24 * $0)) })
        dates += (30...45).map({ initialDate.addingTimeInterval(TimeInterval(3600 * 24 * $0)) })
        dates += (70...190).map({ initialDate.addingTimeInterval(TimeInterval(3600 * 24 * $0)) })
        
        var datesByYearMonth: [YearMonth: [Date]] = [:]
        
        for date in dates {
            let yearMonth = YearMonth(date: date)
            datesByYearMonth[yearMonth, default: []].append(date)
        }
        
        sections = datesByYearMonth.sorted { section1, section2 in
            return section1.key < section2.key
        }
        
        yearsView.update(by: sections.flatMap({ $0.value }))
        
        collectionView.reloadData()
        
        
        
        
        

        
//        let prop1 = CGFloat(yearsArray[0].value.lines) / CGFloat(allItems.count)
        
        
//        let year2 = scrollView.frame.height * prop1
//        
//        let minYearHeight: CGFloat = 30
//        if year2 < minYearHeight {
//            
//        }
        
        //add line, header vertical spacing
        
//        let prop = scrollView.frame.height / scrollView.contentSize.height
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension CollectionController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "ImageTextColCell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeader", for: indexPath)
    }
}

extension CollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageTextColCell else {
            assertionFailure()
            return
        }
        
        let date = sections[indexPath.section].value[indexPath.row]
        cell.textLabel.text = "\(date)"
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        /// fixing iOS11 UICollectionSectionHeader clipping scroll indicator
        /// https://stackoverflow.com/a/46930410/5893286
        if #available(iOS 11.0, *), elementKind == UICollectionElementKindSectionHeader {
            view.layer.zPosition = 0
        }
        
        guard let view = view as? CollectionHeader else {
            return
        }
        
        let date = sections[indexPath.section].value[indexPath.row]
        view.textLabel.text = "\(date)"
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension CollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 4 - 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 44)
    }
}

final class ImageTextColCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.lightGray
        
        imageView.frame = bounds
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        textLabel.frame = bounds
        textLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.numberOfLines = 0
        
        addSubview(imageView)
        addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = bounds
        imageView.frame = bounds
    }
}

final class CollectionHeader: UICollectionReusableView {
    
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.darkGray
        
        textLabel.frame = bounds
        textLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textLabel.textAlignment = .left
        textLabel.font = UIFont.systemFont(ofSize: 14)
        
        addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = bounds
    }
}
