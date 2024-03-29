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

/*
 https://stackoverflow.com/a/34754375/5893286
 
 ! bad solution - needs a lot of memory just to draw it
 */
class StyledCornerView3: UIView {
    
    override func draw(_ rect: CGRect) {
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        //UIColor.white.set()
        superview?.backgroundColor?.set()
        borderPath.fill()
    }
}

final class StyledCornerView4: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
//    override var backgroundColor: UIColor? {
//        didSet {
////            image = resizableImage(16, color: backgroundColor!)
//        }
//    }
    
    private func setup() {
        let cornerRadius: CGFloat = 16
        
        
        let image = resizableImage(cornerRadius, color: backgroundColor!)
        backgroundColor = .clear
        
        
        
        layer.contentsScale = image.scale
        //layer.contentsGravity = .resize
        
        /// doc + https://stackoverflow.com/a/11928188/5893286
        //image.capInsets.top
        let capInset = cornerRadius/image.size.width
        let widthCap = 1 - capInset * 2
        layer.contentsCenter = CGRectMake(capInset,
                                          capInset,
                                          widthCap,
                                          widthCap)
        layer.contents = image.cgImage
        //layer.isGeometryFlipped = true
        
        //UIImage().stretchableImage(withLeftCapWidth: 16, topCapHeight: 16)
        
//        layer.cornerRadius = 16
//        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
//        layer.masksToBounds = true
    }
    
    func resizableImage(_ inset: CGFloat, color: UIColor) -> UIImage {
        let side = inset * 2
        let size = CGSize(width: side, height: side)
        
        //let format = UIGraphicsImageRendererFormat(for: UITraitCollection(displayScale: 1))
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        format.scale = UIScreen.main.scale
        
        let image = UIGraphicsImageRenderer(size: size, format: format).image { context in
            
            color.setFill()
            
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
//            UIBezierPath(roundedRect: rect, cornerRadius: inset).addClip()
            
                        UIBezierPath(roundedRect: rect,
                                     byRoundingCorners: [.topLeft, .topRight, .bottomRight],
                                     cornerRadii: CGSize(width: inset, height: inset)).addClip()
            
            
            context.fill(CGRect(origin: .zero, size: size))
        }
        //        return image
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        return image.resizableImage(withCapInsets: insets, resizingMode: .stretch)
    }
    
}

/*
 maskLayer.path = UIBezierPath(roundedRect: bounds,
 byRoundingCorners: corners,
 cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
 
 similar to
 layer.cornerRadius = 16
 layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
 layer.masksToBounds = true
 */
class CornerView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    //    {
    //        didSet {
    //            updateCorners()
    //        }
    //    }
    
    var corners: UIRectCorner = .allCorners
    //    {
    //        didSet {
    //            updateCorners()
    //        }
    //    }
    
    private let maskLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        layer.mask = maskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCorners()
    }
    
    private func updateCorners() {
        maskLayer.path = UIBezierPath(roundedRect: bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
    }
    
}

/*
 not working for IB bcz `superview?.backgroundColor` = nil
 */
//class OptimizedLabel: UILabel {
//
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//
//        backgroundColor = superview?.backgroundColor
//    }
//}
