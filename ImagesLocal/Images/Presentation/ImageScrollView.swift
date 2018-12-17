//
//  ImageScrollView.swift
//  Images
//
//  Created by Bondar Yaroslav on 10/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ImageScrollView: UIScrollView {
    
    private(set) var imageView = UIImageView()
    
    var image: UIImage? {
        didSet {
            guard let image = image else {
                return
            }
            imageView.image = image
            imageView.frame.size = image.size
            contentSize = image.size
        }
    }
    
    private let maxScaleFromMinScale: CGFloat = 5.0
    private let multiplyScrollGuardFactor: CGFloat = 0.999
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = true
        decelerationRate = UIScrollViewDecelerationRateFast
        
        addSubview(imageView)
        imageView.isUserInteractionEnabled = true
    }
    
    func updateZoom() {
        guard let image = image else {
            return
        }
        setMaxMinZoomScales(for: image.size)
    }
    
    private func setMaxMinZoomScales(for imageSize: CGSize) {
        let xScale = bounds.width / imageSize.width
        let yScale = bounds.height / imageSize.height
        
        // fill width if the image and phone are both portrait or both landscape; otherwise take smaller scale
        let imagePortrait = imageSize.height > imageSize.width
        let phonePortrait = bounds.height >= bounds.width
        
        var minScale = (imagePortrait == phonePortrait) ? xScale : min(xScale, yScale)
        let maxScale = maxScaleFromMinScale * minScale
        
        /// don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
        if minScale > maxScale {
            minScale = maxScale
        }
        
        maximumZoomScale = maxScale
        minimumZoomScale = minScale * multiplyScrollGuardFactor
        zoomScale = minimumZoomScale
    }
    
    func adjustFrameToCenter() {
        var frameToCenter = imageView.frame
        
        /// center horizontally
        if frameToCenter.size.width < bounds.width {
            frameToCenter.origin.x = (bounds.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        /// center vertically
        if frameToCenter.size.height < bounds.height {
            frameToCenter.origin.y = (bounds.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageView.frame = frameToCenter
    }
}
