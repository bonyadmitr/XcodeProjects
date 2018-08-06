//
//  PhotoCell.swift
//  DragDrop
//
//  Created by Bondar Yaroslav on 8/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class PhotoCell: UICollectionViewCell, Reusable {
    
    @IBOutlet private weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 4
        layer.borderColor = UIColor.clear.cgColor
    }
    
    func config(with object: UIImage?) {
        photoImageView.image = object
    }
    
    func setSelection(_ selection: Bool) {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
            if selection {
                self.layer.borderColor = UIColor.gray.cgColor
            } else {
                self.layer.borderColor = UIColor.clear.cgColor
            }
        }, completion: nil)
        
    }
}

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
