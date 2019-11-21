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
    
    func handle(items: [Product.Item]) {
        
        CoreDataStack.shared.performBackgroundTask { context in
            
            let newIds = items.map { $0.id }
            
            let propertyToFetch = #keyPath(Item.id)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Item.className())
            fetchRequest.predicate = NSPredicate(format: "\(propertyToFetch) IN %@", newIds)
            fetchRequest.resultType = .dictionaryResultType
            fetchRequest.propertiesToFetch = [propertyToFetch]
            fetchRequest.includesSubentities = false
            //                    fetchRequest.includesPropertyValues = false
            //                    fetchRequest.includesPendingChanges = true
            //                    fetchRequest.returnsObjectsAsFaults = false
            //                    fetchRequest.returnsDistinctResults = true
            
            guard let existedItems = try? context.fetch(fetchRequest) as? [[String: String]] else {
                assertionFailure()
                return
            }
            
            #if DEBUG
            /// unsafe but will work like assert
            let existedUUIDs = existedItems.map({ $0[propertyToFetch]! })
            #else
            let existedUUIDs = existedItems.compactMap({ $0[propertyToFetch] })
            #endif
            
            assert(existedUUIDs.count == existedItems.count, "we fetch only \(propertyToFetch)")
            
            print("--- existedUUIDs count \(existedUUIDs.count)")
            let newImages = items.filter { !existedUUIDs.contains($0.id) }
            print("--- newImages count \(newImages.count)")
            
            /// save new items
            
            guard !newImages.isEmpty else {
                print("there are no new items")
                return
            }
            
            for newItem in newImages {
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
        
//        currentSnapshot.appendItems(items)
//        dataSource.apply(currentSnapshot, animatingDifferences: true)
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

import Kingfisher
import UIKit

final class PhotoCell: UICollectionViewCell {
}
//
//    let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        //        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        //        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = .lightGray
//        imageView.isOpaque = true
//        return imageView
//    }()
//
//
//    //titleLabel
//    let sizeLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.preferredFont(forTextStyle: .body)
//        label.textAlignment = .center
//        //label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        label.textColor = .white
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//
//    private func setup() {
//        addSubview(imageView)
//
//        addSubview(sizeLabel)
//        assert(subviews.firstIndex(of: sizeLabel) ?? 0 > subviews.firstIndex(of: imageView) ?? 0)
//    }
//
//}


enum Product {
    
    struct Item: Decodable, Equatable, Hashable {
        let id: String
        let name: String
        let price: Int
        let imageUrl: URL
        
        enum CodingKeys: String, CodingKey {
            case id = "product_id"
            case name
            case price
            case imageUrl = "image"
        }
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
    }
    
    struct DetailItem: Decodable {
        let description: String
    }
    
    final class Service {
        func all(handler: @escaping (Result<[Item], Error>) -> Void) {
            Session.withoutAuth
                .request(URLs.Products.all)
                .customValidate()
                .responseObject(keyPath: "products", completion: handler)
        }
        
        func detail(id: String, handler: @escaping (Result<DetailItem, Error>) -> Void) {
            Session.withoutAuth
                .request(URLs.Products.detail(id: id))
                .customValidate()
                .responseObject(completion: handler)
        }
    }
}

import Foundation

enum URLs {
    
    private static let basePath = "https://s3-eu-west-1.amazonaws.com/developer-application-test"
    
    enum Products {
        private static let base = basePath + "/cart"
        
        static let all = base + "/list"
        
        static func detail(id: String) -> String {
            return base + "/\(id)/detail"
        }
    }
    
}

import Foundation

extension DispatchQueue {
    static let background = DispatchQueue.global()
}



import Alamofire

extension Session {
    
    static let withoutAuth: Session = {
        let configuration = URLSessionConfiguration.default
        //configuration.httpAdditionalHeaders = Session.defaultCustomHTTPHeaders
        return Session(configuration: configuration)
    }()
}

import Alamofire

/// here we can change global requests validation
extension DataRequest {
    @discardableResult
    public func customValidate() -> Self {
        return validate(statusCode: 200..<300)
    }
}

extension DownloadRequest {
    @discardableResult
    public func customValidate() -> Self {
        return validate(statusCode: 200..<300)
    }
}

extension JSONDecoder {
    
    /// JSONDecoder keypath
    /// another solution https://github.com/dgrzeszczak/KeyedCodable/
    /// another solution https://gist.github.com/aunnnn/9a6b4608ae49fe1594dbcabd9e607834
    /// another solution https://github.com/aunnnn/NestedDecodable
    ///
    /// code https://gist.github.com/sgr-ksmt/d3b79ed1504768f2058c5ea06dc93698
    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
        let toplevel = try JSONSerialization.jsonObject(with: data)
        if let nestedJson = (toplevel as AnyObject).value(forKeyPath: keyPath) {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
            return try decode(type, from: nestedJsonData)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Nested json not found for key path \"\(keyPath)\""))
        }
    }
}

import Foundation
import Alamofire

extension DataRequest {
    
    @discardableResult
    func responseObject<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) -> Self {
        return responseData(queue: .background) { responseData in
            switch responseData.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    
                    /// Custom Dates https://useyourloaf.com/blog/swift-codable-with-custom-dates/
                    /// custom iso8601 https://stackoverflow.com/a/46458771/5893286
                    decoder.dateDecodingStrategy = .millisecondsSince1970
                    
                    let object = try decoder.decode(T.self, from: data)
                    completion(.success(object))
                } catch {
                    //DecodingError
                    #if DEBUG
                    Self.printAssertFor(responseData: responseData, data: data, error: error)
                    #endif
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// can be named as responseArray
    @discardableResult
    func responseObject<T: Decodable>(completion: @escaping (Result<[T], Error>) -> Void) -> Self {
        return responseData(queue: .background) { responseData in
            switch responseData.result {
            case .success(let data):
                do {
                    let array = (try JSONDecoder().decode([FailableDecodable<T>].self, from: data)).compactMap ({ $0.base })
                    completion(.success(array))
                } catch {
                    //DecodingError
                    #if DEBUG
                    Self.printAssertFor(responseData: responseData, data: data, error: error)
                    #endif
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// can be named as responseArray
    @discardableResult
    func responseObject<T: Decodable>(keyPath: String, completion: @escaping (Result<[T], Error>) -> Void) -> Self {
        return responseData(queue: .background) { responseData in
            switch responseData.result {
            case .success(let data):
                do {
                    let array = (try JSONDecoder().decode([FailableDecodable<T>].self, from: data, keyPath: keyPath)).compactMap ({ $0.base })
                    completion(.success(array))
                } catch {
                    //DecodingError
                    #if DEBUG
                    Self.printAssertFor(responseData: responseData, data: data, error: error)
                    #endif
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func printAssertFor(responseData: AFDataResponse<Data>, data: Data, error: Error) {
        print("\n\n\n⚠️⚠️⚠️ failed request with:")
        print("- response:", responseData.response ?? "response nil")
        print("- data:", String(data: data, encoding: .utf8) ?? "failed data encoding")
        print("- error:", error.localizedDescription)
        //assertionFailure(error.debugDescription)
    }
}

/// source https://stackoverflow.com/a/46369152/5893286
struct FailableDecodable<Base : Decodable> : Decodable {
    let base: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self.base = try container.decode(Base.self)
        } catch {
//            assertionFailure("- \(error.localizedDescription)\n\(error)")
            self.base = nil
        }
        
    }
}

/// there is no CustomDebugStringConvertible bcz of error:
/// Extension of protocol 'Error' cannot have an inheritance clause
extension Error {
    var debugDescription: String {
        return String(describing: self)
    }
}
