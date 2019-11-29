import UIKit
import CoreData

// TODO: UICollectionViewDiffableDataSourceReference vs UICollectionViewDiffableDataSource

/// UICollectionViewDiffableDataSource + NSFetchedResultsController
/// https://schiavo.me/2019/coredata-diffabledatasource/
/// https://stackoverflow.com/q/58029290/5893286

extension ProductsListController {
    
    final class View: UIView, NSFetchedResultsControllerDelegate {
        
        typealias Model = Product
        typealias Item = ProductItemDB
        typealias Cell = ImageTextCell
        typealias SectionType = Int
        
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
        
        private var currentSnapshot: NSDiffableDataSourceSnapshot<SectionType, Item> = {
            var snapshot = NSDiffableDataSourceSnapshot<SectionType, Item>()
            snapshot.appendSections([0])
            return snapshot
        }()
        
        /// article https://medium.com/@jamesrochabrun/uicollectionviewdiffabledatasource-and-decodable-step-by-step-6b727dd2485
        /// project from article https://github.com/jamesrochabrun/UICollectionViewDiffableDataSource
        /// ru article https://dou.ua/lenta/articles/ui-collection-view-data-source/
        /// project from ru article https://github.com/IceFloe/UICollectionViewDiffableDataSource
        lazy var dataSource: UICollectionViewDiffableDataSource<SectionType, Item> = {
            return UICollectionViewDiffableDataSource<SectionType, Item>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
                
                // TODO: check weak self
                
                guard let cell = collectionView.dequeue(cell: Cell.self, for: indexPath) else {
                    assertionFailure()
                    return nil
                }
                cell.setup(for: item)
                return cell
            }
        }()
        
        lazy var activityIndicator: UIActivityIndicatorView = {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.frame = bounds
            activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            activityIndicator.color = .label
            return activityIndicator
        }()
        
        lazy var fetchedResultsController: NSFetchedResultsController<ProductItemDB> = {
            let fetchRequest: NSFetchRequest<ProductItemDB> = ProductItemDB.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Item.id), ascending: true)]
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                fetchRequest.fetchBatchSize = 20
            } else {
                fetchRequest.fetchBatchSize = 10
            }
            
            //fetchRequest.shouldRefreshRefetchedObjects = false
            let context = CoreDataStack.shared.viewContext
            return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
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
            _ = dataSource
            
            dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
                
                guard let view = collectionView.dequeue(supplementaryView: TitleSupplementaryView.self, kind: kind, for: indexPath) else {
                    assertionFailure()
                    return UICollectionReusableView()
                }
                
                view.titleLabel.text = self.fetchedResultsController.sections?[indexPath.section].name
                
                return view
            }
            
            addSubview(collectionView)
            
            /// removed collectionView.autoresizingMask if used constraints
            //collectionView.translatesAutoresizingMaskIntoConstraints = false
            //NSLayoutConstraint.activate([
            //    collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            //    collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            //    collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            //    collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            //])
            
            fetchedResultsController.delegate = self
            performFetch()
        }
        
        func performFetch() {
            try? fetchedResultsController.performFetch()
            updateDataSource(animated: false)
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
        
        func deleteAllItems() {
            currentSnapshot.deleteAllItems()
            currentSnapshot.appendSections([0])
            dataSource.apply(currentSnapshot, animatingDifferences: true)
        }
        
        @objc private func pullToRefresh() {
            refreshData?(refreshControl)
        }
        
        func updateDataSource(animated: Bool) {
            var snapshot = NSDiffableDataSourceSnapshot<SectionType, Item>()
            
            if let sections = fetchedResultsController.sections {
                
                /// simple snapshot for one section
                if sections.count == 1 {
                    snapshot.appendSections([0])
                    snapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
                } else {
                    
                    let sectionsArray = (0..<sections.count).map { $0 }
                    snapshot.appendSections(sectionsArray)
                    
                    for (sectionIndex, section) in sections.enumerated() {
                        let items = (0..<section.numberOfObjects).map { itemIndex -> ProductItemDB in
                            let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                            return fetchedResultsController.object(at: indexPath)
                        }
                        snapshot.appendItems(items, toSection: sectionIndex)
                    }
                }

            }
            
            currentSnapshot = snapshot
            dataSource.apply(snapshot, animatingDifferences: animated)
        }
        
        // MARK: - NSFetchedResultsControllerDelegate
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            updateDataSource(animated: true)
        }
        
    }
    
}
