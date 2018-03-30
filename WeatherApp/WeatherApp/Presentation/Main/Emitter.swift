//
//  Emitter.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 02/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

struct Emitter {
    
    static func getCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = #imageLiteral(resourceName: "im_snowflake").mask(with: UIColor.white)?.cgImage
        cell.birthRate = 1
        cell.lifetime = 30
        cell.velocity = 25
        cell.velocityRange = 10
        cell.emissionLongitude = 180.radians
        cell.emissionRange = 45.radians
        cell.scale = 0.07
        cell.scaleRange = 0.03
        cell.spin = 0.8
        cell.spinRange = 0.3
        return cell
    }
    
    static func getLayerWith(cells: [CAEmitterCell], width: CGFloat) -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterCells = cells
        emitter.emitterSize = CGSize(width: width, height: 1)
        emitter.emitterPosition = CGPoint(x: width / 2, y: -10)
        return emitter
    }
    
}
