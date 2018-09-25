//
//  ViewController.swift
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
    var handleExclusiveInteractionEnabled = false
    
    
    private weak var scrollView: UIScrollView?

    private var handleView: UIImageView?
    private var trackView: UIImageView?
    
    var isDisabled = false
    
    var originalHeight: CGFloat = 0
    var originalYOffset: CGFloat = 0
    
    let trackWidth: CGFloat = 2
    let handleWidth: CGFloat = 4
    var horizontalOffset: CGFloat = 0
    
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
    
    private func setUpViews() {
        guard self.handleView == nil, self.trackView == nil else {
            return
        }
        
        let trackImage = ScrollBar.verticalCapsuleImage(withWidth: trackWidth)
        let trackView = UIImageView(image: trackImage)
        trackView.tintColor = .lightGray
        self.trackView = trackView
        addSubview(trackView)
        
        let handleImage = ScrollBar.verticalCapsuleImage(withWidth: handleWidth)
        let handleView = UIImageView(image: handleImage)
        handleView.tintColor = .black
        self.handleView = handleView
        addSubview(handleView)
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
        
        let halfWidth = scrollBarWidth / 2
        
        if #available(iOS 11.0, *) {
            insets = scrollView.adjustedContentInset
        }
        
        scrollViewFrame.size.height -= insets.top + insets.bottom
        
        var largeTitleDelta: CGFloat = 0
        // TODO: _insetForLargeTitles
//        if (_insetForLargeTitles) {
//            largeTitleDelta = fabs(MIN(insets.top + contentOffset.y, 0.0f));
//        }
        
        let height = scrollViewFrame.size.height - (verticalInset.top + verticalInset.bottom) - largeTitleDelta
        
        let horizontalOffset = halfWidth - edgeInset
        self.horizontalOffset = (horizontalOffset > 0.0) ? horizontalOffset : 0.0
        
        var frame = CGRect.zero
        frame.size.width = scrollBarWidth
        frame.size.height = isDragging ? originalHeight : height
        frame.origin.x = scrollViewFrame.size.width - (edgeInset + halfWidth)
        
        if #available(iOS 11.0, *) {
            frame.origin.x -= scrollView.safeAreaInsets.right
        }
        
        frame.origin.x = min(frame.origin.x, scrollViewFrame.size.width - scrollBarWidth)
        
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
        trackFrame.size.height = frame.size.height
        trackFrame.origin.x = CGFloat(ceilf(Float( ((frame.size.width - trackWidth) * 0.5) + horizontalOffset) ))
        trackView?.frame = trackFrame.integral
        
        // Don't handle automatic layout when dragging; we'll do that manually elsewhere
        if isDragging || isDisabled {
            return
        }
        
        // The frame of the handle
        var handleFrame = CGRect.zero
        handleFrame.size.width = handleWidth
        handleFrame.size.height = heightOfHandleForContentSize()
        handleFrame.origin.x = CGFloat(ceilf(Float( ((frame.size.width - handleWidth) * 0.5) + horizontalOffset) ))
        
        // Work out the y offset of the handle
        var contentInset: UIEdgeInsets = scrollView.contentInset
        if #available(iOS 11.0, *) {
            contentInset = scrollView.safeAreaInsets
        }
        
        let contentOffset: CGPoint = scrollView.contentOffset
        let contentSize: CGSize = scrollView.contentSize
        let scrollViewFrame: CGRect = scrollView.frame
        
        let scrollableHeight: CGFloat = (contentSize.height + contentInset.top + contentInset.bottom) - scrollViewFrame.size.height
        let scrollProgress: CGFloat = (contentOffset.y + contentInset.top) / scrollableHeight
        handleFrame.origin.y = (frame.size.height - handleFrame.size.height) * scrollProgress
        if contentOffset.y < -contentInset.top {
            // The top
            handleFrame.size.height -= -contentOffset.y - contentInset.top
            handleFrame.size.height = max(handleFrame.size.height, (trackWidth * 2 + 2))
        } else if contentOffset.y + scrollViewFrame.size.height > contentSize.height + contentInset.bottom {
            // The bottom
            let adjustedContentOffset: CGFloat = contentOffset.y + scrollViewFrame.size.height
            let delta: CGFloat = adjustedContentOffset - (contentSize.height + contentInset.bottom)
            handleFrame.size.height -= delta
            handleFrame.size.height = max(handleFrame.size.height, (trackWidth * 2 + 2))
            handleFrame.origin.y = frame.size.height - handleFrame.size.height
        }
        
        // Clamp to the bounds of the frame
        handleFrame.origin.y = max(handleFrame.origin.y, 0.0)
        handleFrame.origin.y = min(handleFrame.origin.y, (frame.size.height - handleFrame.size.height))
        
        handleView?.frame = handleFrame
    }
    
    func heightOfHandleForContentSize() -> CGFloat {
        guard let scrollView = scrollView else {
            return scrollBarHandleMinHeight
        }
        
        let heightRatio: CGFloat = scrollView.frame.height / scrollView.contentSize.height
        let height: CGFloat = frame.size.height * heightRatio
        return CGFloat(max(floorf(Float(height)), Float(scrollBarHandleMinHeight)))
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if handleExclusiveInteractionEnabled, let handleView = handleView {
            let handleMinY = handleView.frame.minY
            let handleMaxY = handleView.frame.maxY
            return (0 <= point.x) && (handleMinY <= point.y) && (point.y <= handleMaxY)
        } else {
            return super.point(inside: point, with: event)
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setUpViews()
    }
    
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


class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let scrollBar = ScrollBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollBar.add(to: tableView)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
