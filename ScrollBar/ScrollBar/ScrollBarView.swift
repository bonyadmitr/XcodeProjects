//
//  ScrollBarView.swift
//  ScrollBar
//
//  Created by Bondar Yaroslav on 9/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// https://github.com/TimOliver/TOScrollBar
final class ScrollBarView: UIView {  
    
    private static let scrollBarHandleImage = #imageLiteral(resourceName: "scroll_bar_view")
    
    /// The width of this control (44 is minimum recommended tapping space)
    private let scrollBarWidth: CGFloat = 44
    
    /// The minimum usable size to which the handle can shrink
    private let scrollBarHandleMinHeight: CGFloat = 64
    
    private let edgeInset: CGFloat = scrollBarHandleImage.size.width * 0.5
    
    private var isDragging = false
    
    
    /// The amount of padding above and below the scroll bar (Only top and bottom values are counted.)
    private let verticalInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    
    /** When enabled, the scroll bar will only respond to direct touches to the handle control.
     Touches to the track will be passed to the UI controls beneath it.
     Default is NO. */
    // TODO: need to create pan gester with begin on tap
    private var handleExclusiveInteractionEnabled = true
    
    private weak var scrollView: UIScrollView?
    
    private lazy var handleView: UIImageView = {
        return UIImageView(image: ScrollBarView.scrollBarHandleImage)
    }()
    
    private lazy var trackView: UIImageView = {
        let trackImage = UIImage.verticalCapsuleImage(withWidth: trackWidth)
        let trackView = UIImageView(image: trackImage)
        trackView.tintColor = .lightGray
        return trackView
    }()
    
    private var isDisabled = false
    
    private var originalHeight: CGFloat = 0
    private var originalYOffset: CGFloat = 0
    
    private let trackWidth: CGFloat = 2
    private let handleWidth: CGFloat = scrollBarHandleImage.size.width
    private var horizontalOffset: CGFloat = 0
    
    private var originalTopInset: CGFloat = 0
    private var yOffset: CGFloat = 0
    
    private var isInsetForLargeTitles = false
    
    private let insetsLabel: TextInsetsLabel = {
        let insetsLabel = TextInsetsLabel()
        insetsLabel.text = "Some text"
        insetsLabel.textAlignment = .center
        insetsLabel.font = UIFont.systemFont(ofSize: 11)
        insetsLabel.backgroundColor = UIColor.blue
        insetsLabel.textColor = UIColor.white
        insetsLabel.center.x -= 60
        insetsLabel.textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        insetsLabel.sizeToFit()
        insetsLabel.layer.cornerRadius = insetsLabel.frame.height * 0.5
        insetsLabel.layer.masksToBounds = true
        return insetsLabel
    }()
    
    var isAutoHideLabel = true {
        didSet {
            if isAutoHideLabel {
                
            }
        }
    }
    
    private let animationDuration = 0.3
    
    private func hideLabelAnimated() {
        UIView.animate(withDuration: animationDuration) { 
            self.alpha = 0
        }
    }
    
    private func showLabelAnimated() {
        UIView.animate(withDuration: animationDuration) { 
            self.alpha = 1
        }
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
//        addSubview(trackView)
        addSubview(handleView)
        addSubview(insetsLabel)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(scrollBarGestureRecognized))
        addGestureRecognizer(gestureRecognizer)
    }
    
    func add(to scrollView: UIScrollView) {
        if self.scrollView == scrollView {
            return
        }
        
        restore(scrollView: self.scrollView)
        self.scrollView = scrollView
        config(scrollView: scrollView)
        scrollView.addSubview(self)
        layoutInScrollView()
    }
    
    private func config(scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new], context: nil)
        scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: [.new], context: nil)
    }
    
    private func restore(scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }
        scrollView.showsVerticalScrollIndicator = true
        scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
        scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
    }
    
    deinit {
        restore(scrollView: scrollView)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let scrollView = scrollView else {
            return
        }
        
        isDisabled = scrollView.contentSize.height < scrollView.frame.height
        isHidden = isDisabled
        
        if isDisabled {
            return
        }
        
        layoutInScrollView()
        setNeedsLayout()
    }
    
    private func layoutInScrollView() {
        guard let scrollView = scrollView else {
            return
        }
        
        var scrollViewFrame = scrollView.frame
        let halfWidth = scrollBarWidth * 0.5
        
        let contentInset: UIEdgeInsets
        if #available(iOS 11.0, *) {
            contentInset = scrollView.adjustedContentInset
        } else {
            contentInset = scrollView.contentInset
        }
        
//        scrollViewFrame.size.height -= contentInset.top + contentInset.bottom
        
        let largeTitleDelta: CGFloat
        if isInsetForLargeTitles {
            largeTitleDelta = 0//abs(min(contentInset.top + scrollView.contentOffset.y, 0))
        } else {
            largeTitleDelta = 0
        }
        
        let height = scrollViewFrame.height - (verticalInset.top + verticalInset.bottom) - largeTitleDelta
        
        let horizontalOffset = halfWidth - edgeInset
        self.horizontalOffset = (horizontalOffset > 0.0) ? horizontalOffset : 0.0
        
        var frame = CGRect.zero
        frame.size.width = scrollBarWidth
        frame.size.height = isDragging ? originalHeight : height
        frame.origin.x = scrollViewFrame.width - (edgeInset + halfWidth)
        
        if #available(iOS 11.0, *) {
            frame.origin.x -= scrollView.safeAreaInsets.right
        }
        
        frame.origin.x = min(frame.origin.x, scrollViewFrame.width - scrollBarWidth)
        
        if isDragging {
            frame.origin.y = originalYOffset
        } else {
            frame.origin.y = verticalInset.top
//            frame.origin.y += contentInset.top
            frame.origin.y += largeTitleDelta
        }
        
        frame.origin.y += scrollView.contentOffset.y
        
        self.frame = frame
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let scrollView = scrollView else {
            return
        }
        
        trackView.frame = CGRect(x: ceil((frame.width - trackWidth) * 0.5 + horizontalOffset),
                                 y: 0, width: trackWidth, height: frame.height).integral
        
        // Don't handle automatic layout when dragging; we'll do that manually elsewhere
        if isDragging || isDisabled {
            return
        }
        
        var handleFrame = CGRect(x: ceil((frame.width - handleWidth) * 0.5 + horizontalOffset),
                                 y: 0, width: handleWidth, height: heightOfHandleForContentSize)
        
        // Work out the y offset of the handle
        // TODO: check other scrollView.contentInset for 
        let contentInset: UIEdgeInsets
        if #available(iOS 11.0, *) {
            contentInset = scrollView.safeAreaInsets
        } else {
            contentInset = scrollView.contentInset
        }
        
        let contentOffset = scrollView.contentOffset
        let contentSize = scrollView.contentSize
        
        let scrollableHeight = contentSize.height + contentInset.top + contentInset.bottom - scrollView.frame.height
        let scrollProgress = (contentOffset.y + contentInset.top) / scrollableHeight
        handleFrame.origin.y = scrollProgress * (frame.height - handleFrame.height)
        
        /// removed scaling on top and end of scrollView
//        if contentOffset.y < -contentInset.top {
//            // The top
////            handleFrame.size.height -= -contentOffset.y - contentInset.top
////            handleFrame.size.height = max(handleFrame.height, trackWidth * 2 + 2)
//        } else if contentOffset.y + scrollView.frame.height > contentSize.height + contentInset.bottom {
//            // The bottom
////            let adjustedContentOffset: CGFloat = contentOffset.y + scrollView.frame.height
////            let delta = adjustedContentOffset - (contentSize.height + contentInset.bottom)
////            handleFrame.size.height -= delta
////            handleFrame.size.height = max(handleFrame.height, trackWidth * 2 + 2)
//            handleFrame.origin.y = frame.height - handleFrame.height
//        }
        
        // Clamp to the bounds of the frame
        handleFrame.origin.y = max(handleFrame.origin.y, 0.0)
        handleFrame.origin.y = min(handleFrame.origin.y, frame.height - handleFrame.height)
        
        handleView.frame = handleFrame
        insetsLabel.center.y = handleView.center.y
    }
    
    var heightOfHandleForContentSize: CGFloat {
        guard let scrollView = scrollView else {
            return scrollBarHandleMinHeight
        }
        
        let heightRatio = scrollView.frame.height / scrollView.contentSize.height
        let height = frame.height * heightRatio
        return max(floor(height), scrollBarHandleMinHeight)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if handleExclusiveInteractionEnabled {
            let handleMinY = handleView.frame.minY
            let handleMaxY = handleView.frame.maxY
            return (0 <= point.x) && (handleMinY <= point.y) && (point.y <= handleMaxY)
        } else {
            return super.point(inside: point, with: event)
        }
    }
    
    // MARK: - scrollBarGestureRecognized
    
    @objc private func scrollBarGestureRecognized(_ gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: self)
        
        switch gesture.state {
        case .began:
            gestureBegan(at: touchPoint)
        case .changed:
            gestureMoved(to: touchPoint)
        case .ended, .cancelled:
            gestureEnded()
        case .possible, .failed:
            break
        }
    }
    
    private func gestureBegan(at touchPoint: CGPoint) {
        if isDisabled {
            return
        }
        
        guard let scrollView = scrollView else {
            return
        }
        
        scrollView.isScrollEnabled = false
        isDragging = true
        
        originalHeight = frame.height
        originalYOffset = frame.origin.y - scrollView.contentOffset.y
        
        if #available(iOS 11.0, *) {
            originalTopInset = scrollView.adjustedContentInset.top
        } else {
            originalTopInset = scrollView.contentInset.top
        }
        
        var handleFrame = handleView.frame
        let handleY = handleFrame.origin.y
        
        if touchPoint.y > (handleY - 20), touchPoint.y < handleY + (handleFrame.height + 20) {
            yOffset = touchPoint.y - handleY
            return
        }
        
        if !handleExclusiveInteractionEnabled {
            let halfHeight = handleFrame.height * 0.5
            
            var destinationYOffset = touchPoint.y - halfHeight
            destinationYOffset = max(0, destinationYOffset)
            destinationYOffset = min(frame.height - halfHeight, destinationYOffset)
            
            yOffset = touchPoint.y - destinationYOffset
            handleFrame.origin.y = destinationYOffset
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
                self.handleView.frame = handleFrame
                self.insetsLabel.center.y = self.handleView.center.y
            })
            
            setScrollYOffsetForHandleYOffset(floor(destinationYOffset), animated: false)
        }
    }
    
    func setScrollYOffsetForHandleYOffset(_ yOffset: CGFloat, animated: Bool) {
        guard let scrollView = scrollView else {
            return
        }
        
        let heightRange = trackView.frame.height - handleView.frame.height
        var yOffset = max(0, yOffset)
        yOffset = min(heightRange, yOffset)
        
        let positionRatio = yOffset / heightRange
        
        let contentSize = scrollView.contentSize
        
        var contentInset = scrollView.contentInset
        if #available(iOS 11.0, *) {
            contentInset = scrollView.adjustedContentInset
        }
        contentInset.top = originalTopInset
        
        let totalScrollSize = contentSize.height + contentInset.top + contentInset.bottom - scrollView.frame.height
        var scrollOffset = totalScrollSize * positionRatio
        scrollOffset -= contentInset.top
        
        var contentOffset = scrollView.contentOffset
        contentOffset.y = scrollOffset
        
        
        scrollView.setContentOffset(contentOffset, animated: false)
        // Animate to help coax the large title navigation bar to behave
        //        if #available(iOS 11.0, *) {
        //            UIView.animate(withDuration: animated ? 0.1 : 0.00001) {
        //                scrollView.setContentOffset(contentOffset, animated: false)
        //            }
        //        } else {
        //            scrollView.setContentOffset(contentOffset, animated: false)
        //        }
    }
    
    private func gestureMoved(to touchPoint: CGPoint) {
        if isDisabled {
            return
        }
        
        var handleFrame = handleView.frame
        let trackFrame = trackView.frame
        let minimumY: CGFloat = 0
        let maximumY = trackFrame.height - handleFrame.height
        
        /// to prevent too fast scroll
        //        if handleExclusiveInteractionEnabled {
        //            if touchPoint.y < (handleFrame.origin.y - 20) || touchPoint.y > handleFrame.origin.y + (handleFrame.height + 20) {
        //                // This touch is not on the handle; eject.
        //                return
        //            }
        //        }
        
        // Apply the updated Y value plus the previous offset
        var delta = handleFrame.origin.y
        handleFrame.origin.y = touchPoint.y - yOffset
        
        //Clamp the handle, and adjust the y offset to counter going outside the bounds
        if handleFrame.origin.y < minimumY {
            yOffset += handleFrame.origin.y
            yOffset = max(minimumY, yOffset)
            handleFrame.origin.y = minimumY
            
        } else if handleFrame.origin.y > maximumY {
            let handleOverflow = handleFrame.maxY - trackFrame.height
            yOffset += handleOverflow
            yOffset = min(yOffset, handleFrame.height)
            handleFrame.origin.y = min(handleFrame.origin.y, maximumY)
        }
        
        handleView.frame = handleFrame
        insetsLabel.center.y = handleView.center.y
        
        delta -= handleFrame.origin.y
        delta = abs(delta)
        
        // If the delta is not 0.0, but we're at either extreme,
        // this is first frame we've since reaching that point.
        // Play a taptic feedback impact
        //        if delta > CGFloat.ulpOfOne, handleFrame.minY < CGFloat.ulpOfOne || handleFrame.minY >= maximumY - CGFloat.ulpOfOne {
        //            feedbackGenerator.impactOccurred()
        //        }
        
        // If the user is doing really granualar swipes, add a subtle amount
        // of vertical animation so the scroll view isn't jumping on each frame
        setScrollYOffsetForHandleYOffset(floor(handleFrame.origin.y), animated: false) //(delta < 0.51f)
        
    }
    
    private func gestureEnded() {
        scrollView?.isScrollEnabled = true
        isDragging = false
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [], animations: { 
            self.layoutInScrollView()
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        
        if isDisabled || isDragging {
            return result
        }
        
        // If the user contacts the screen in a swiping motion,
        // the scroll view will automatically highjack the touch
        // event unless we explicitly override it here.
        scrollView?.isScrollEnabled = result != self
        return result
        
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
