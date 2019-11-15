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

final class ProductsListView: UIView {
    
    typealias Model = Product
    typealias Item = Model.Item
    typealias Cell = ImageTextCell
    
    
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
        
        return collectionView
    }()
    
    private var currentSnapshot: NSDiffableDataSourceSnapshot<String, Item> = {
        var snapshot = NSDiffableDataSourceSnapshot<String, Item>()
        snapshot.appendSections(["\(Model.self)"])
        return snapshot
    }()
    
    /// article https://medium.com/@jamesrochabrun/uicollectionviewdiffabledatasource-and-decodable-step-by-step-6b727dd2485
    /// project from article https://github.com/jamesrochabrun/UICollectionViewDiffableDataSource
    /// ru article https://dou.ua/lenta/articles/ui-collection-view-data-source/
    /// project from ru article https://github.com/IceFloe/UICollectionViewDiffableDataSource
    lazy var dataSource: UICollectionViewDiffableDataSource<String, Item> = {
        return UICollectionViewDiffableDataSource<String, Item>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
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
    
    func handle(items: [Item]) {
        DispatchQueue.main.async {
            self.currentSnapshot.appendItems(items)
            self.dataSource.apply(self.currentSnapshot, animatingDifferences: true)
        }
    }
    
}

final class ProductsListController: UIViewController {
    
    typealias Model = Product
    typealias Item = Model.Item
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
        service.all { [weak self] result in
            switch result {
            case .success(let items):
                self?.vcView.handle(items: items)
            case .failure(let error):
                print(error.debugDescription)
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
    
    final class Service {
        func all(handler: @escaping (Result<[Item], Error>) -> Void) {
            Session.withoutAuth
                .request(URLs.Products.all)
                .customValidate()
                .responseObject(keyPath: "products", completion: handler)
        }
    }
}

import Foundation

enum URLs {
    
    private static let basePath = "https://s3-eu-west-1.amazonaws.com/developer-application-test/"
    
    enum Products {
        private static let base = basePath + "cart/"
        
        static let all = base + "list"
        
        static func detail(id: Int) -> String {
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
        assertionFailure(error.debugDescription)
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
