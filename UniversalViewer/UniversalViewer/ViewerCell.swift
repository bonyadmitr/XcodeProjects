//
//  ViewerCell.swift
//  UniversalViewer
//
//  Created by Bondar Yaroslav on 2/1/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ViewerCell: UICollectionViewCell {
    
    weak var view: UIView? {
        willSet {
            view?.removeFromSuperview()
        }
        didSet {
            guard let view = view else {
                return
            }
            addSubview(view)
//            view.translatesAutoresizingMaskIntoConstraints = false
//            view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//            view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//            view.topAnchor.constraint(equalTo: topAnchor).isActive = true
//            view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            view.frame = bounds
            view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
    
    var tapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapGesture))
        addGestureRecognizer(tapGesture)
    }
    
    private var isNeedLayout = true
    
    @objc func actionTapGesture(_ gesture: UITapGestureRecognizer) {
        isNeedLayout = false
        tapHandler?()
        print("qweqw")
    }
    
    var object: ViewObject?
    
    func fill(with object: ViewObject) {
        self.object = object
        view = object.view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isNeedLayout {
            object?.relayout()
        } else {
            isNeedLayout = true
        }
        
//        view?.frame = bounds
        
    }
}
