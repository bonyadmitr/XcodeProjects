//
//  ViewController.swift
//  ProductsList
//
//  Created by Bondar Yaroslav on 11/15/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import CoreData

// TODO: a lot of:
/**
 CODE (Developer or QA can see changes):
 swiftlint
 clear code
 debug floating window
 demo mode without server + without internet (save some jsons to the bundle)
 add main.swift
 remove storyboard (save LaunchScreen only)
 router for navigation (+ mb window manager)
 mb more asserts
 unit tests
 UI tests
 DI
 protocols for view-model
 add ".xcconfig" files
 logging
 mb any scripts or automatization (like fastlane, swiftgen, ...)
 
 REQUIRED FEATURES (User can see changes):
 pull to refresh
 activityIndicator for network
 context menu (UIContextMenuInteractionDelegate)
 cache by core data for offline using
 search
 sorting
 error presenting (mb ToastController later(+UIPresentationController) )
 error handling (+ InternalError)
 list empty state
 internet restoration (wifi + mobile)
 http requests canceling
 split controller
 pass photo to detail screen
 app restoration
 several windows by SceneDelegate
 localization (+ RTL)
 app rater
 Large Title nav bar
 accessibility (voice, big fonts, mb colors)
 
 ADDITIONAL FEATURES:
 self sizing cells layout
 custom layout (for photos only + mb grid/list) (maybe by UICollectionViewCompositionalLayout)
 layouts changing
 animated layout changing
 tvOS support (didUpdateFocus, dark mode for tvOS)
 shortcuts (UIKeyCommand)
 app extensions (widget(today), file provider(files))
 background updates
 share items
 spotlight (CoreSpotlight)
 siri shotcuts
 crashlytics
 any analitica
 settings screen (+ tab bar if need) (icon, version, feedback, app review...) (for more need to check Settings project)
 settings bundle
 theme switching manualy
 localization switching manualy
 iMessage App
 local notifications (to check updates)
 passcode (+ TouchID and FaceID)
 vibrations on touch
 sounds on touch
 tutorials spotlight
 onboarding screens
 check new updates
 "whats new" screen
 Parallax Effect with UIMotionEffect (for background)
 external screen support
 translucent nav bar (+ fix all scrolls)
 mb something for NaturalLanguage + Create ML
 image recognition
 macCatalyst
 macCatalyst Menu Bar article https://www.zachsim.one/blog/2019/8/4/customising-the-menu-bar-of-a-catalyst-app-using-uimenubuilder
 
 DONE:
 swift package manager
 cleared MVC (by separate view, services)
 items list
 item detail
 landscape
 ScaledHeightImageView
 typealias
 Alamofire helpers
 Decodable helpers (FailableDecodable + keyPath)
 image caching by Kingfisher
 used xibs and code for layout (AutoLayout + mask)
 scroll + no scroll layout (detail screen)
 asserts
 UICollectionViewDiffableDataSource + NSDiffableDataSourceSnapshot
 - latest ios (13) for new API
 
 CLEARED CODE:
 private
 let
 names
 headers
 constants (for magic numbers)
 willSet
 safe code (less '!')
 
 THERE IS NO:
 keychain
 push notifications
 Auth 2
 keyaboard handlers
 pagination
 sync background actions with server
 */

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

final class ProductsListController: UIViewController {
    
    typealias Model = Product
//    typealias Item = Model.Item
    typealias Item = ProductItemDB
    typealias View = ProductsListView
    
    private let service = Model.Service()
    
    override func loadView() {
        self.view = View()
    }
    
    private lazy var vcView = view as! View
//    private lazy var vcView: View = {
//        return view as! View
//        /// more safely
//        //if let view = self.view as? View {
//        //    return view
//        //} else {
//        //    assertionFailure("override func loadView")
//        //    return View()
//        //}
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Products"
        
        /// to prevent call from background and crash "UI API called on a background thread"
        _ = vcView
        
        vcView.collectionView.delegate = self
        
        fetch()
        
        vcView.refreshData = { [weak self] refreshControl in
            print("refreshData")
            // TODO: assert main
            self?.vcView.deleteAllItems()
            self?.service.all { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let items):
                        self?.vcView.handle(items: items)
                    case .failure(let error):
                        print(error.debugDescription)
                    }
                    
                    refreshControl.endRefreshing()
                }
            }
        }
        
        
        
        /// https://sarunw.com/posts/uinavigationbar-changes-in-ios13/
        //let appearance = UINavigationBarAppearance()
        //appearance.configureWithDefaultBackground()
        //UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        ///  https://stackoverflow.com/a/25421617/5893286
        //navigationController?.view.backgroundColor = .systemBackground
        
        /// in IB
        //navigationController?.navigationBar.isTranslucent = false
    }

    private func fetch() {
        vcView.activityIndicator.startAnimating()
        
        service.all { [weak self] result in
            DispatchQueue.main.async {
                self?.vcView.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let items):
                    self?.vcView.handle(items: items)
                case .failure(let error):
                    print(error.debugDescription)
                }
            }
        }
    }
    
}

extension ProductsListController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select cell at \(indexPath.item)")
        
        guard let item = vcView.dataSource.itemIdentifier(for: indexPath) else {
            assertionFailure()
            return
        }
        
        let detailVC = ProductDetailController()
        detailVC.item = item
        
        #if os(tvOS)
        present(detailVC, animated: true, completion: nil)
        #else
        navigationController?.pushViewController(detailVC, animated: true)
        #endif
    }
    
}

/// there is no CustomDebugStringConvertible bcz of error:
/// Extension of protocol 'Error' cannot have an inheritance clause
extension Error {
    var debugDescription: String {
        return String(describing: self)
    }
}
