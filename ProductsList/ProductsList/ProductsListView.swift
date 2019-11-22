import UIKit
import CoreData

final class ProductsListView: UIView {
    
    typealias Model = Product
//    typealias Item = Model.Item
    typealias Item = ProductItemDB
    typealias Cell = ImageTextCell
    typealias SectionType = Int
//    typealias ItemDB = ProductItemDB
    
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
        
        collectionView.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellWithReuseIdentifier: cellId)
        //collectionView.register(Cell.self, forCellWithReuseIdentifier: cellId)
        
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as? Cell else {
                assertionFailure()
                return nil
            }
            
            //cell.delegate = self
            //cell.indexPath = indexPath
            
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
    
    private lazy var fetchedResultsController: NSFetchedResultsController<ProductItemDB> = {
        let fetchRequest: NSFetchRequest<ProductItemDB> = ProductItemDB.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(ProductItemDB.id), ascending: false)]
        
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
        addSubview(collectionView)
        
        fetchedResultsController.delegate = self
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
    
    func handle(items newItems: [Product.Item]) {
        
        CoreDataStack.shared.performBackgroundTask { context in
            
            let newIds = newItems.map { $0.id }
            let propertyToFetch = #keyPath(Item.id)
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Item.className())
            fetchRequest.predicate = NSPredicate(format: "\(propertyToFetch) IN %@", newIds)
            fetchRequest.resultType = .dictionaryResultType
            fetchRequest.propertiesToFetch = [propertyToFetch]
            fetchRequest.includesSubentities = false
            //fetchRequest.includesPropertyValues = false
            //fetchRequest.includesPendingChanges = true
            //fetchRequest.returnsObjectsAsFaults = false
            //fetchRequest.returnsDistinctResults = true
            
            guard let existedDictIds = try? context.fetch(fetchRequest) as? [[String: String]] else {
                assertionFailure("must be set 'fetchRequest.resultType = .dictionaryResultType'")
                return
            }
            
            let existedIds = existedDictIds.compactMap { $0[propertyToFetch] }
            print("--- existed items count \(existedIds.count)")
            assert(existedIds.count == existedDictIds.count, "\(existedIds.count) != \(existedDictIds.count)")
            
            let itemsToSave = newItems.filter { !existedIds.contains($0.id) }
            print("--- items to save count \(itemsToSave.count)")
            
            guard !itemsToSave.isEmpty else {
                print("--- there are no new items")
                return
            }
            
            /// save new items
            for newItem in itemsToSave {
                let item = Item(context: context)
                item.id = newItem.id
                item.name = newItem.name
                item.imageUrl = newItem.imageUrl
                item.price = Int16(newItem.price)
            }
            
            do {
                try context.save()
            } catch {
                assertionFailure(error.debugDescription)
            }
            
            #if DEBUG
            /// check saved items count
            CoreDataStack.shared.performBackgroundTask { context in
                let fetchRequestCount = NSFetchRequest<NSFetchRequestResult>(entityName: Item.className())
                fetchRequestCount.resultType = .countResultType
                guard let savedItemsCount = (try? context.fetch(fetchRequestCount) as? [Int])?.first else {
                    assertionFailure()
                    return
                }
                print("--- saved items count:", savedItemsCount)
                assert(existedIds.count + itemsToSave.count == savedItemsCount, "")
            }

            #endif

        }
    }
    
    func deleteAllItems() {
        currentSnapshot.deleteAllItems()
        currentSnapshot.appendSections([0])
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    @objc private func pullToRefresh() {
        // TODO: check call after first one (refreshControl.isRefreshing)
        refreshData?(refreshControl)
        refreshControl.endRefreshing()
    }
    
    func updateDataSource(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        currentSnapshot = snapshot
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension ProductsListView: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateDataSource(animated: true)
    }
    
}
