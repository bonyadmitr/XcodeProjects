//
//  LayerResizeView.swift
//  СameraManager
//
//  Created by Bondar Yaroslav on 05/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class LayerResizeView: UIView {
    
    convenience init(layer: CALayer) {
        self.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        resizingLayer = layer
        add(layer: layer)
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
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundColor = UIColor.black
    }
    
    var resizingLayer: CALayer? {
        willSet {
            guard let resizingLayer = resizingLayer else { return }
            resizingLayer.removeFromSuperlayer()
        }
        didSet {
            guard let resizingLayer = resizingLayer else { return }
            add(layer: resizingLayer)
        }
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if layer == self.layer {
            resizingLayer?.frame = bounds
        }
    }
    
    /// need this func bcz didSet not call in init
    private func add(layer: CALayer) {
        layer.backgroundColor = UIColor.red.cgColor
        layer.frame = frame
        self.layer.addSublayer(layer)
    }
    
    func add(to view: UIView) {
        view.addSubview(self)
        frame = view.frame
    }
}
