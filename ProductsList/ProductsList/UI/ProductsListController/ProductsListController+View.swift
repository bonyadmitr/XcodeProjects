import UIKit

// TODO: UICollectionViewDiffableDataSourceReference vs UICollectionViewDiffableDataSource

/// UICollectionViewDiffableDataSource + NSFetchedResultsController
/// https://schiavo.me/2019/coredata-diffabledatasource/
/// https://stackoverflow.com/q/58029290/5893286

extension ProductsListController {
    
    final class View: UIView {
        
        var refreshData: ( (UIRefreshControl) -> Void )?
        
        private lazy var refreshControl: UIRefreshControl = {
            let newValue = UIRefreshControl()
            newValue.tintColor = .label
            newValue.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
            return newValue
        }()
        
        #if targetEnvironment(macCatalyst)
        private let padding: CGFloat = 16
        #elseif os(iOS)
        private let padding: CGFloat = 1
        #else /// tvOS
        private let padding: CGFloat = 32
        #endif
        
        private let cellId = String(describing: Cell.self)
        
        lazy var collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
            collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            collectionView.alwaysBounceVertical = true
            collectionView.isOpaque = true
            collectionView.registerNibCell(Cell.self)
            collectionView.registerHeader(TitleSupplementaryView.self)
            
            #if os(iOS)
            collectionView.backgroundColor = .systemBackground
            #endif
            
            #if targetEnvironment(macCatalyst)
            collectionView.contentInset = .init(top: padding, left: padding, bottom: padding, right: padding)
            #elseif os(iOS)
            collectionView.contentInset = .zero
            #else /// tvOS
            collectionView.contentInset = .init(top: padding, left: padding, bottom: padding, right: padding)
            #endif
            
            collectionView.refreshControl = refreshControl
            return collectionView
        }()
        
        lazy var activityIndicator: UIActivityIndicatorView = {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.frame = bounds
            activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            activityIndicator.color = .label
            return activityIndicator
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        private func setup() {
            addSubview(collectionView)
            
            /// removed collectionView.autoresizingMask if used constraints
            //collectionView.translatesAutoresizingMaskIntoConstraints = false
            //NSLayoutConstraint.activate([
            //    collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            //    collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            //    collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            //    collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            //])
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            updateItemSize()
        }

        private func updateItemSize() {
            let viewWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right

            #if targetEnvironment(macCatalyst)
            /// resizing config
            let resizeCellNorPadding = false

            let minimumItemSize: CGFloat = 150
            let columns: CGFloat = resizeCellNorPadding ? floor(viewWidth / minimumItemSize) : floor(viewWidth) / minimumItemSize
            let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
            #elseif os(iOS)
            let columns: CGFloat = 2
            let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
            #else /// tvOS
            let columns: CGFloat = 5
            // TODO: remove from here
            let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
            #endif

            let itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = itemSize
                layout.minimumInteritemSpacing = padding
                layout.minimumLineSpacing = padding
            }
        }
        
        @objc private func pullToRefresh() {
            refreshData?(refreshControl)
        }
        
    }
    
}
