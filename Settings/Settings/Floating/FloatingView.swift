//
//  FloatingView.swift
//  WindowFloating
//
//  Created by Bondar Yaroslav on 4/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

#if DEBUG
import UIKit

protocol FloatingViewDelegate: class {
    func didTapButton()
}

final class FloatingView: UIView {
    
    private static let startPosition = CGPoint(x: 0, y: UIScreen.main.bounds.height / 2)
    private static let size = CGSize(width: 60, height: 60)
    
    weak var delegate: FloatingViewDelegate?
    
    convenience init() {
        let rect = CGRect(origin: FloatingView.startPosition, size: FloatingView.size)
        self.init(frame: rect)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.8
        layer.cornerRadius = bounds.width * 0.5 /// round button
        layer.shadowOffset = .zero
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func tap() {
        delegate?.didTapButton()
    }
    
    func updateOrientation(with newSize: CGSize) {
        let oldSize = CGSize(width: newSize.height, height: newSize.width)
        let percent = center.y / oldSize.height * 100
        let newOrigin = newSize.height * percent / 100
        let originX = (frame.origin.x < newSize.height / 2) ? 30 : newSize.width - 30
        center = CGPoint(x: originX, y: newOrigin)
    }
}
#endif
