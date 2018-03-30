//
//  AppIconPicker.swift
//  AlternateIcon
//
//  Created by Bondar Yaroslav on 13/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class AppIconPicker: UICollectionView {
    
    var icons = [UIImage]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        dataSource = self
        delegate = self
        register(AppIconCell.self, forCellWithReuseIdentifier: "cell")
        
        DispatchQueue.global().async {
            self.icons = AppIconManager.shared.icons
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
}

extension AppIconPicker: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AppIconCell
        cell.iconImageView.image = icons[indexPath.row]
        return cell
    }
}

extension AppIconPicker: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let icon = AppIcon.allValues[indexPath.row]
        FabricManager.shared.log(appIcon: icon)
        if #available(iOS 10.3, *) {
            AppIconManager.shared.change(to: icon, withAlert: true)
        }
    }
}
