import UIKit
import Kingfisher

/// Content View added for simplifying copying of all content and possible insets
/// changed subtitleLabel content hugging priority and content compression resistance
final class ImageTextCell: UICollectionViewCell {
    
    typealias Item = ProductItemDB
    typealias CellDelegate = ImageTextCellDelegate
    
    @Style(style: .common)
    @IBOutlet private var imageView: UIImageView!
    
    @Style(style: .title)
    @IBOutlet private var titleLabel: UILabel!
    
    @Style(style: .subtitle)
    @IBOutlet private var subtitleLabel: UILabel!
    
    private var item: Item?
    private var isContextMenuDidAppear = false
    weak var delegate: CellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addInteraction()
    }
    
    private func addInteraction() {
        #if os(iOS)
        isUserInteractionEnabled = true
        let interaction = UIContextMenuInteraction(delegate: self)
        addInteraction(interaction)
        #else /// tvOS
        //let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        //longPressGesture.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue),
        //                                      NSNumber(value: UIPress.PressType.playPause.rawValue)]
        //addGestureRecognizer(longPressGesture)
        //
        //
        //layer.shadowRadius = 16
        //layer.shadowColor = UIColor.black.cgColor
        //layer.shadowOffset = CGSize(width: 0, height: 16)
        ///// turned off at start
        //layer.shadowOpacity = 0.0
        #endif
    }
    
    func setup(for item: Item) {
        self.item = item
        titleLabel.text = item.name
        subtitleLabel.text = "Price: \(item.price)"
        
        imageView.kf.cancelDownloadTask()
        imageView.kf.setImage(with: item.imageUrl, placeholder: UIImage(systemName: "photo"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}

/// without delegate can be used:
/// func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
#if os(iOS)
/// rus tutorial https://habr.com/ru/company/apphud/blog/455854/
/// eng tutorial https://kylebashour.com/posts/ios-13-context-menus
/// full description  https://kylebashour.com/posts/context-menu-guide
/// code example https://github.com/kylebshr/context-menus/tree/kyle/suggested-actions
@available(tvOS, unavailable)
extension ImageTextCell: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                willDisplayMenuFor configuration: UIContextMenuConfiguration,
                                animator: UIContextMenuInteractionAnimating?) {
        
        delegate?.photoCellPreivewWillAppear()
        
        animator?.addCompletion { [weak self] in
            self?.delegate?.photoCellPreivewDidAppear()
            self?.isContextMenuDidAppear = true
        }
    }
    
    /// long tap on view to open context menu
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        guard
            let delegate = self.delegate,
            let item = self.item
        else {
            assertionFailure()
            return nil
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            #if targetEnvironment(macCatalyst)
            /// for macCatalyst controller will not be presented.
            /// viewDidLoad will not be called but controller will be created so pass nil.
            return nil
            #else
            /// "return nil" will focus cell
            return ProductDetailController(item: item)
            #endif
        }, actionProvider: { _ in
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                delegate.photoCell(cell: self, didShare: item)
            }
            return UIMenu(title: "", children: [shareAction])
        })
    }
    
    /// tap on context preview
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                                animator: UIContextMenuInteractionCommitAnimating) {
        
        /// animation fix https://stackoverflow.com/a/57731149
        /// needs only to dismiss preview without open animation.
        //animator.preferredCommitStyle = .dismiss
        
        guard
            let delegate = self.delegate,
            let item = self.item
        else {
            assertionFailure()
            return
        }
        
        animator.addCompletion {
            if let vc = animator.previewViewController {
                delegate.photoCellDidTapOnPreivew(previewController: vc, item: item)
            }
        }
    }
    
    /// not called for macCatalyst
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                willEndFor configuration: UIContextMenuConfiguration,
                                animator: UIContextMenuInteractionAnimating?) {
        
        if isContextMenuDidAppear {
            isContextMenuDidAppear = false
            delegate?.photoCellPreivewWillDisappear()
            
            animator?.addCompletion { [weak self] in
                self?.delegate?.photoCellPreivewDidDisappear()
            }
        } else {
            animator?.addCompletion {// [weak self] in
                print("preview dragged without menu appear")
            }
        }

    }
    
}
#endif

protocol ImageTextCellDelegate: class {
    typealias Cell = ImageTextCell
    
    func photoCell(cell: Cell, didShare item: Cell.Item)
    func photoCellDidTapOnPreivew(previewController: UIViewController, item: Cell.Item)
    
    func photoCellPreivewWillAppear()
    func photoCellPreivewDidAppear()

    func photoCellPreivewWillDisappear()
    func photoCellPreivewDidDisappear()
}

extension ImageTextCellDelegate {
    func photoCellPreivewWillAppear() {}
    func photoCellPreivewDidAppear() {}

    func photoCellPreivewWillDisappear() {}
    func photoCellPreivewDidDisappear() {}
}
