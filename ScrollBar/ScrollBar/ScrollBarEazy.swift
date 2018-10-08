//
//  ScrollBarEazy.swift
//  ScrollBar
//
//  Created by Bondar Yaroslav on 10/8/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ScrollBarEazy: UIView {
    
    private weak var scrollView: UIScrollView?
    
    private lazy var handleView: UIView = {
        let handleImage = UIImage.verticalCapsuleImage(withWidth: handleWidth)
        let handleView = UIImageView(image: handleImage)
        handleView.tintColor = .black
        return handleView
    }()
    
    private let handleWidth: CGFloat = 4
    
    private let scrollBarHandleMinHeight: CGFloat = 36
    
    /// The amount of padding above and below the scroll bar (Only top and bottom values are counted.)
    private let verticalInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
    
    var heightOfHandleForContentSize: CGFloat {
        guard let scrollView = scrollView else {
            return scrollBarHandleMinHeight
        }
        
        let heightRatio = scrollView.frame.height / scrollView.contentSize.height
        let height = frame.height * heightRatio
        return max(floor(height), scrollBarHandleMinHeight)
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
        addSubview(handleView)
    }
    
    func observe(scrollView: UIScrollView) {
        restore(scrollView: self.scrollView)
        self.scrollView = scrollView
        config(scrollView: scrollView)
    }
    
    private func config(scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }
        
//        scrollView.showsVerticalScrollIndicator = false
        scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new], context: nil)
        scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: [.new], context: nil)
    }
    
    private func restore(scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }
//        scrollView.showsVerticalScrollIndicator = true
        scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
        scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
    }
    
    deinit {
        restore(scrollView: scrollView)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        setNeedsLayout()
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            let newHeight = newValue.height - (verticalInset.top + verticalInset.bottom) 
            super.frame = CGRect(x: newValue.origin.x, y: newValue.origin.y + verticalInset.top, width: newValue.width, height: newHeight)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let scrollView = scrollView, scrollView.contentSize.height > 0 else {
            return
        }
        
        // Work out the y offset of the handle
        // TODO: check other scrollView.contentInset for 
//        let contentInset: UIEdgeInsets
//        if #available(iOS 11.0, *) {
//            contentInset = scrollView.safeAreaInsets
//        } else {
//            contentInset = scrollView.contentInset
//        }        
//        let contentOffset = scrollView.contentOffset
//        let contentSize = scrollView.contentSize
//        let scrollableHeight = scrollView.contentSize.height - scrollView.frame.height + contentInset.top + contentInset.bottom
        
        let scrollableHeight = scrollView.contentSize.height - scrollView.frame.height
        let scrollProgress = scrollView.contentOffset.y / scrollableHeight
        
        let handleOffset = scrollProgress * (frame.height - handleView.frame.height)
        
        let handleFrame = CGRect(x: 0,
                                 y: handleOffset,
                                 width: handleWidth,
                                 height: heightOfHandleForContentSize)
        
//        if scrollView.contentOffset.y + scrollView.frame.height >
        
        handleView.frame = handleFrame
        
        
        

//        
//        let contentOffset = scrollView.contentOffset
//        let contentSize = scrollView.contentSize
//        
//        let scrollableHeight = contentSize.height + contentInset.top + contentInset.bottom - scrollView.frame.height
//        let scrollProgress = (contentOffset.y + contentInset.top) / scrollableHeight
//        handleFrame.origin.y = scrollProgress * (frame.height - handleFrame.height)
//        
//        if contentOffset.y < -contentInset.top {
//            // The top
//            handleFrame.size.height -= -contentOffset.y - contentInset.top
//            handleFrame.size.height = max(handleFrame.height, 4 * 2 + 2)
//        } else if contentOffset.y + scrollView.frame.height > contentSize.height + contentInset.bottom {
//            // The bottom
//            let adjustedContentOffset: CGFloat = contentOffset.y + scrollView.frame.height
//            let delta = adjustedContentOffset - (contentSize.height + contentInset.bottom)
//            handleFrame.size.height -= delta
//            handleFrame.size.height = max(handleFrame.height, 4 * 2 + 2)
//            handleFrame.origin.y = frame.height - handleFrame.height
//        }
//        
//        // Clamp to the bounds of the frame
//        handleFrame.origin.y = max(handleFrame.origin.y, 0.0)
//        handleFrame.origin.y = min(handleFrame.origin.y, frame.height - handleFrame.height)
//        
//        handleView.frame = handleFrame
    }
    

}














private extension UIImage {
    static func verticalCapsuleImage(withWidth width: CGFloat) -> UIImage? {
        let radius = width * 0.5
        let frame = CGRect(x: 0, y: 0, width: width + 1, height: width + 1)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, _: false, _: 0.0)
        UIBezierPath(roundedRect: frame, cornerRadius: radius).fill()
        guard var image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        image = image.resizableImage(withCapInsets: UIEdgeInsetsMake(radius, radius, radius, radius), resizingMode: .stretch)
        image = image.withRenderingMode(.alwaysTemplate)
        return image
    }
}
