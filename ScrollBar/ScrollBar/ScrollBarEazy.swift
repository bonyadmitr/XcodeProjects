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
        handleView.tintColor = .red
        return handleView
    }()
    
    /// 2.33 - apple default
    private let handleWidth: CGFloat = 2.33
    
    /// 36 - apple default
    private let scrollBarHandleMinHeight: CGFloat = 36
    
    /// The amount of padding above, below and right the scroll bar (left doesn't used)
    /// 3 - apple default for all sides
    private let insets = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 3)
    
    private var lastContentHeight: CGFloat = 0
    
    private var heightOfHandleForContentSize: CGFloat = 1
    
    private func updateHeightOfHandleForContentSize() {
        guard let scrollView = scrollView else {
            heightOfHandleForContentSize = scrollBarHandleMinHeight
            return
        }
        
        let heightRatio = scrollView.frame.height / scrollView.contentSize.height
        let height = frame.height * heightRatio
        heightOfHandleForContentSize = max(floor(height), scrollBarHandleMinHeight)
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
        
        guard let scrollView = scrollView else {
            assertionFailure()
            return
        }
        
        if keyPath == #keyPath(UIScrollView.contentSize), lastContentHeight != scrollView.contentSize.height {
            lastContentHeight = scrollView.contentSize.height
            updateHeightOfHandleForContentSize()
        }
        
        setNeedsLayout()
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            let newHeight = newValue.height - (insets.top + insets.bottom) 
            super.frame = CGRect(x: newValue.origin.x, y: newValue.origin.y + insets.top, width: newValue.width, height: newHeight)
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let scrollView = scrollView, scrollView.contentSize.height > 0 else {
            return
        }
        
        func getHandleHeight(for negativeInset: CGFloat) -> CGFloat {
            let handleHeightRatio = (heightOfHandleForContentSize + negativeInset) / heightOfHandleForContentSize
            let maybeNewHandleHeight = heightOfHandleForContentSize * handleHeightRatio
            return max(maybeNewHandleHeight, 7)
        }
         
        let contentInset = scrollView.contentInset
//        let contentOffsetY = scrollView.contentOffset.y
//        let contentSize = scrollView.contentSize
        
        let scrollableHeight = scrollView.contentSize.height - scrollView.frame.height + contentInset.top + contentInset.bottom
        let scrollProgress = (scrollView.contentOffset.y + contentInset.top) / scrollableHeight
        var handleOffset = scrollProgress * (frame.height - handleView.frame.height)
        
        let handleHeight: CGFloat
        /// check top negative offset
        if scrollView.contentOffset.y < -contentInset.top {
            let negativeInset = scrollView.contentOffset.y + contentInset.top
            handleHeight = getHandleHeight(for: negativeInset)
            
            /// to prevent handleView overlap verticalInset
            handleOffset = max(handleOffset, 0)
            
        /// check bottom negative offset
        } else if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height + contentInset.bottom {
            let negativeInset = scrollView.contentSize.height + contentInset.bottom - (scrollView.contentOffset.y + scrollView.frame.height)
            handleHeight = getHandleHeight(for: negativeInset)
            
            /// to prevent handleView overlap verticalInset
            handleOffset = frame.height - handleView.frame.height
        } else {
            handleHeight = heightOfHandleForContentSize
        }
        
        
        let handleFrame = CGRect(x: frame.width - handleWidth - insets.right,
                                 y: handleOffset,
                                 width: handleWidth,
                                 height: handleHeight)
        
        handleView.frame = handleFrame
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
