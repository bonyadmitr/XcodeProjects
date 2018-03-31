//
//  SegmentedColControl.swift
//  SegmentedColControl
//
//  Created by Bondar Yaroslav on 28/03/2017.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import UIKit

class SegmentedColControl: UIControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Private properies
    
    private var layout = ColumnsCollectionLayout()
    private var collectionView: UICollectionView!
    
    // MARK: - Main properies
    
    var images = [UIImage]() {
        didSet {
            if images.count == 0 { return }
            layout.cellsPerRow = images.count
            setCellHeight()
            collectionView.reloadData()
        }
    }
    
    var selectedIndex = 0
    
    // MARK: - Customization
    
    var cellHeight = CellHeight.imageWith(10) {
        didSet { setCellHeight() }
    }
    
    var selectingView = SelectingView()
    
    var selectingViewColor: UIColor? {
        get { return selectingView.backgroundColor }
        set { selectingView.backgroundColor = newValue }
    }
    
    var selectingViewSize: SelectingViewSize {
        get { return selectingView.selectingViewSize }
        set { selectingView.selectingViewSize = newValue }
    }
    var selectingAnimationType: SelectiongAnimation {
        get { return selectingView.selectingAnimationType }
        set { selectingView.selectingAnimationType = newValue }
    }
    var animationTime: TimeInterval {
        get { return selectingView.animationTime }
        set { selectingView.animationTime = newValue }
    }
    
    // MARK: - Setup
    
    func setup() {
        setupCollectionView()
        setupSelectingView()
    }
    
    func setupCollectionView() {
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false
        
        addSubview(collectionView)
    }
    
    func setupSelectingView() {
        selectingView.backgroundColor = UIColor.cyan
        selectingView.layer.cornerRadius = 4
        insertSubview(selectingView, at: 0)
    }
    
    private func setCellHeight() {
        switch cellHeight {
        case .image:
            layout.cellHeight = images.first!.size.height
        case .imageWith(let height):
            layout.cellHeight = images.first!.size.height + height
        case .custom(let height):
            layout.cellHeight = height
        }
    }
}



// MARK: - UICollectionViewDataSource

extension SegmentedColControl: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.iconImageView.image = images[indexPath.row]
        
        if indexPath.row == selectedIndex {
            selectingView.setSize(for: cell.frame)
        }
        
        return cell
    }
}



// MARK: - UICollectionViewDelegate

extension SegmentedColControl: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let selectedIndex = collectionView.indexPathsForSelectedItems?.first, selectedIndex == indexPath {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        selectingView.animate(for: cell.frame)
        selectedIndex = indexPath.row
        sendActions(for: .valueChanged)
    }
}
