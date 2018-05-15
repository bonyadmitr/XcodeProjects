//
//  TableCell.swift
//  Calendar2
//
//  Created by zdaecqze zdaecq on 29.08.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var tableView: CollectionTableView!
    var numberOfDays = 0
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.reloadData()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
//        let nib = UINib(nibName: simpleColCellID, bundle: nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: simpleColCellID)
        
        collectionView.register(CodeColCell.self, forCellWithReuseIdentifier: codeColCellId)
    }

    func config(with object: Int) {
        numberOfDays = object
        collectionView.contentOffset = tableView.contentOffsets[indexPath.row]
    }
}

extension TableCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: codeColCellId, for: indexPath) as! CodeColCell
        cell.someLabel.text = String(indexPath.row + 1)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableView.contentOffsets[indexPath.row] = collectionView.contentOffset
//        contentOffset = collectionView.contentOffset
    }
}

