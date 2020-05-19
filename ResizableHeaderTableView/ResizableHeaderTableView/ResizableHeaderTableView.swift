import UIKit

/// theme https://stackoverflow.com/a/34689293/5893286
final class ResizableHeaderTableView: UITableView {
    
    private var lastUpdatedFrame: CGRect = .zero
    
    /// if was created in IB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sizeHeaderToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if lastUpdatedFrame != frame {
            lastUpdatedFrame = frame
            sizeHeaderToFit()
        }
    }
    
    /// call for init(frame:
    func sizeHeaderToFit() {
        guard let header = tableHeaderView else {
            return
        }
        
        let targetWidth = bounds.width
        let fittingSize = CGSize(width: targetWidth,
                                 height: UIView.layoutFittingCompressedSize.height)
        let targetHeight = header.systemLayoutSizeFitting(fittingSize,
                                                          withHorizontalFittingPriority: .required,
                                                          verticalFittingPriority: .defaultLow).height
        
        header.frame.size.height = targetHeight
        
        /// we need to update contentSize.
        /// without this set you will need to call reloadData().
        tableHeaderView = header
    }
}
