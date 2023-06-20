//
//  ViewController.swift
//  CornerRadiusReview
//
//  Created by Yaroslav Bondar on 08.06.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        collectionView.register(UINib(nibName: "TaskViewCell", bundle: nil), forCellWithReuseIdentifier: "TaskViewCell")
//        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = columnLayout
        collectionView.reloadData()
    }


}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColCell", for: indexPath) as? ColCell else {
            assertionFailure()
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = "\(indexPath.item)"
        
        return cell
    }
}

final class ColCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}




final class StyledCornerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        layer.masksToBounds = true
    }

}

final class StyledCornerView2: CornerView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        cornerRadius = 16
        corners = [.topLeft, .topRight, .bottomRight]
    }
    
}
