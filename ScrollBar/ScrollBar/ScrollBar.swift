//
//  ScrollBar.swift
//  ScrollBar
//
//  Created by Bondar Yaroslav on 9/25/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// https://github.com/TimOliver/TOScrollBar

final class ScrollBar: UIView {
    
    /// The width of this control (44 is minimum recommended tapping space)
    private let scrollBarWidth: CGFloat = 44
    
    /// The minimum usable size to which the handle can shrink
    private let scrollBarHandleMinHeight: CGFloat = 64
    
    private let edgeInset: CGFloat = 7.5
    
    var isDragging = false
    
    
    /// The amount of padding above and below the scroll bar (Only top and bottom values are counted.)
    private let verticalInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    
    
    /** When enabled, the scroll bar will only respond to direct touches to the handle control.
     Touches to the track will be passed to the UI controls beneath it.
     Default is NO. */
    var handleExclusiveInteractionEnabled = true
    
    
    private weak var scrollView: UIScrollView?
    
    private lazy var handleView: UIImageView = {
        let handleImage = ScrollBar.verticalCapsuleImage(withWidth: handleWidth)
        let handleView = UIImageView(image: handleImage)
        handleView.tintColor = .black
        return handleView
    }()
    
    private lazy var trackView: UIImageView = {
        let trackImage = ScrollBar.verticalCapsuleImage(withWidth: trackWidth)
        let trackView = UIImageView(image: trackImage)
        trackView.tintColor = .lightGray
        return trackView
    }()
    
    var isDisabled = false
    
    var originalHeight: CGFloat = 0
    var originalYOffset: CGFloat = 0
    
    let trackWidth: CGFloat = 2
    let handleWidth: CGFloat = 4
    var horizontalOffset: CGFloat = 0
    
    var originalTopInset: CGFloat = 0
    var yOffset: CGFloat = 0
    
    var isInsetForLargeTitles = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(trackView)
        addSubview(handleView)
        
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
    
    //    private var observation: NSKeyValueObservation?
    
    private func config(scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }
        //        observation = scrollView.observe(\.contentOffset) { scrollView, change in
        //            
        //        }
        
        
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
        var insets = scrollView.contentInset
        let contentOffset = scrollView.contentOffset
        
        let halfWidth = scrollBarWidth * 0.5
        
        if #available(iOS 11.0, *) {
            insets = scrollView.adjustedContentInset
        }
        
        scrollViewFrame.size.height -= insets.top + insets.bottom
        
        var largeTitleDelta: CGFloat = 0
        if isInsetForLargeTitles {
            largeTitleDelta = abs(min(insets.top + contentOffset.y, 0))
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
            frame.origin.y += insets.top
            frame.origin.y += largeTitleDelta
        }
        
        frame.origin.y += contentOffset.y
        
        self.frame = frame
        
        superview?.bringSubview(toFront: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let scrollView = scrollView else {
            return
        }
        
        let frame = self.frame
        
        // The frame of the track
        var trackFrame = CGRect.zero
        trackFrame.size.width = trackWidth
        trackFrame.size.height = frame.height 
        trackFrame.origin.x = ceil((frame.width - trackWidth) * 0.5 + horizontalOffset)
        trackView.frame = trackFrame.integral
        
        // Don't handle automatic layout when dragging; we'll do that manually elsewhere
        if isDragging || isDisabled {
            return
        }
        
        // The frame of the handle
        var handleFrame = CGRect.zero
        handleFrame.size.width = handleWidth
        handleFrame.size.height = heightOfHandleForContentSize()
        handleFrame.origin.x = ceil((frame.width - handleWidth) * 0.5 + horizontalOffset)
        
        // Work out the y offset of the handle
        var contentInset: UIEdgeInsets = scrollView.contentInset
        if #available(iOS 11.0, *) {
            contentInset = scrollView.safeAreaInsets
        }
        
        let contentOffset: CGPoint = scrollView.contentOffset
        let contentSize: CGSize = scrollView.contentSize
        let scrollViewFrame: CGRect = scrollView.frame
        
        let scrollableHeight: CGFloat = (contentSize.height + contentInset.top + contentInset.bottom) - scrollViewFrame.height
        let scrollProgress: CGFloat = (contentOffset.y + contentInset.top) / scrollableHeight
        handleFrame.origin.y = scrollProgress * (frame.height - handleFrame.height)
        if contentOffset.y < -contentInset.top {
            // The top
            handleFrame.size.height -= -contentOffset.y - contentInset.top
            handleFrame.size.height = max(handleFrame.height, trackWidth * 2 + 2)
        } else if contentOffset.y + scrollViewFrame.height > contentSize.height + contentInset.bottom {
            // The bottom
            let adjustedContentOffset: CGFloat = contentOffset.y + scrollViewFrame.height
            let delta: CGFloat = adjustedContentOffset - (contentSize.height + contentInset.bottom)
            handleFrame.size.height -= delta
            handleFrame.size.height = max(handleFrame.height, trackWidth * 2 + 2)
            handleFrame.origin.y = frame.height - handleFrame.height
        }
        
        // Clamp to the bounds of the frame
        handleFrame.origin.y = max(handleFrame.origin.y, 0.0)
        handleFrame.origin.y = min(handleFrame.origin.y, (frame.height - handleFrame.height))
        
        handleView.frame = handleFrame
    }
    
    func heightOfHandleForContentSize() -> CGFloat {
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
        
        if touchPoint.y > (handleFrame.origin.y - 20), touchPoint.y < handleFrame.origin.y + (handleFrame.height + 20) {
            yOffset = touchPoint.y - handleFrame.origin.y
            return
        }
        
        if !handleExclusiveInteractionEnabled {
            let halfHeight = handleFrame.height * 0.5
            
            var destinationYOffset = touchPoint.y - halfHeight
            destinationYOffset = max(0.0, destinationYOffset)
            destinationYOffset = min(frame.height - halfHeight, destinationYOffset)
            
            yOffset = touchPoint.y - destinationYOffset
            handleFrame.origin.y = destinationYOffset
            
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
                self.handleView.frame = handleFrame
            })
            
            setScrollYOffsetForHandleYOffset(floor(destinationYOffset), animated: false)
        }
    }
    
    func setScrollYOffsetForHandleYOffset(_ yOffset: CGFloat, animated: Bool) {
        guard let scrollView = scrollView else {
            return
        }
        
        var yOffset = yOffset
        let heightRange = trackView.frame.height - handleView.frame.height
        yOffset = max(0.0, yOffset)
        yOffset = min(heightRange, yOffset)
        
        let positionRatio: CGFloat = yOffset / heightRange
        
        let frame: CGRect = scrollView.frame
        var inset: UIEdgeInsets = scrollView.contentInset
        let contentSize: CGSize = scrollView.contentSize
        
        if #available(iOS 11.0, *) {
            inset = scrollView.adjustedContentInset
        }
        inset.top = originalTopInset
        
        let totalScrollSize: CGFloat = (contentSize.height + inset.top + inset.bottom) - frame.height
        var scrollOffset: CGFloat = totalScrollSize * positionRatio
        scrollOffset -= inset.top
        
        var contentOffset: CGPoint = scrollView.contentOffset
        contentOffset.y = scrollOffset
        
        // Animate to help coax the large title navigation bar to behave
        if #available(iOS 11.0, *) {
            UIView.animate(withDuration: animated ? 0.1 : 0.00001, animations: {
                scrollView.setContentOffset(contentOffset, animated: false)
            })
        } else {
            scrollView.setContentOffset(contentOffset, animated: false)
        }
    }
    
    private func gestureMoved(to touchPoint: CGPoint) {
        if isDisabled {
            return
        }
        
        var handleFrame: CGRect = handleView.frame
        let trackFrame: CGRect = trackView.frame
        let minimumY: CGFloat = 0.0
        let maximumY = trackFrame.height - handleFrame.height
        
        if handleExclusiveInteractionEnabled {
            if touchPoint.y < (handleFrame.origin.y - 20) || touchPoint.y > handleFrame.origin.y + (handleFrame.height + 20) {
                // This touch is not on the handle; eject.
                return
            }
        }
        
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
    
    // MARK: - refactor
    
//    override func willMove(toSuperview newSuperview: UIView?) {
//        super.willMove(toSuperview: newSuperview)
//        setUpViews()
//    }
    
    class func verticalCapsuleImage(withWidth width: CGFloat) -> UIImage? {
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
