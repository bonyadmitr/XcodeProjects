//
//  ViewController.swift
//  CornerRadiusReview
//
//  Created by Yaroslav Bondar on 08.06.2023.
//

import UIKit

    private let columnLayout: UICollectionViewCompositionalLayout = {
        
        let deviceInset: CGFloat = 16
        
        let columns: CGFloat = 4
        let inset: CGFloat = 4
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / columns),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: deviceInset - inset, bottom: inset, trailing: deviceInset - inset)
        
        
        return UICollectionViewCompositionalLayout(section: section)
    }()
