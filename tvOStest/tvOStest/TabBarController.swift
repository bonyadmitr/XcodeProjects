//
//  TabBarController.swift
//  tvOStest
//
//  Created by Bondar Yaroslav on 8/10/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchContainerDisplay()
    }
    
    func searchContainerDisplay(){
        guard let navController = SearchController.resultsController() else {
            return
        }
        viewControllers?.append(navController)
    }
}

class CollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: 100, height: 100)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ColCell
        cell.someLabel.text = "cell \(indexPath.item)"
        cell.imageView.image = UIImage(color: .red, size: .init(width: 100, height: 100))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 140)
    }
}

final class ColCell: UICollectionViewCell {
    @IBOutlet weak var someLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        someLabel.removeConstraints(someLabel.constraints)
        
//        someLabel.translatesAutoresizingMaskIntoConstraints = false
//        someLabel.leadingAnchor.constraint(equalTo: imageView.focusedFrameGuide.leadingAnchor).isActive = true
//        someLabel.trailingAnchor.constraint(equalTo: imageView.focusedFrameGuide.trailingAnchor).isActive = true
//        someLabel.bottomAnchor.constraint(equalTo: imageView.focusedFrameGuide.bottomAnchor).isActive = true
    }
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
