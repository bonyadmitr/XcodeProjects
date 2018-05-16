//
//  ColumnsCollectionLayoutController.swift
//  CollectionViewLayouts
//
//  Created by Bondar Yaroslav on 18.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ColumnsCollectionLayoutController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
//        collectionView.delegate = self
//        let nib = UINib(nibName: simpleColCellID, bundle: nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: simpleColCellID)
        
        collectionView.register(CodeColCell.self, forCellWithReuseIdentifier: codeColCellId)
        collectionView.scrollToBottom(animated: false)
    }
}

extension ColumnsCollectionLayoutController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: simpleColCellID, for: indexPath) as! SimpleColCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: codeColCellId, for: indexPath) as! CodeColCell
        cell.someLabel.text = "Row \(indexPath.row + 1)"
        return cell
    }
}
