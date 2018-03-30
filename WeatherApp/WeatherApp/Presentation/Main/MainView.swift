//
//  MainView.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 16/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class MainView: UIView {
    
    private var emitter: CAEmitterLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        emitter = CAEmitterLayer() //Emitter.getLayerWith(cells: [Emitter.getCell()], width: frame.width)
        layer.insertSublayer(emitter, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emitter.emitterSize.width = frame.width
    }
}
