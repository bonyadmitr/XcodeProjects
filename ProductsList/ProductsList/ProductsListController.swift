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

final class ProductsListController: UIViewController, ErrorPresenter {
    
    typealias Model = Product
//    typealias Item = Model.Item
    typealias Item = ProductItemDB
    typealias View = ProductsListView
    
    private enum SortOrder: Int, CaseIterable {
        case id = 0
        case name
        
        var title: String {
            switch self {
            case .id:
                return "Created Date"
            case .name:
                return "Name"
            }
        }
    }
    
    private let service = Model.Service()
    private lazy var storage = Item.Storage()
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        setupSearchController()
        fetch()
        
        vcView.refreshData = { [weak self] refreshControl in
            print("refreshData")
            
            self?.service.all { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let items):
                        self?.handle(items: items)
                    case .failure(let error):
                        self?.showErrorAlert(for: error)
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
    
    /// https://developer.apple.com/documentation/uikit/view_controllers/displaying_searchable_content_by_using_a_search_controller
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.placeholder = "Search name/price/description"
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.spellCheckingType = .no
        searchController.searchBar.enablesReturnKeyAutomatically = true /// default true for searchBar
        searchController.searchBar.smartQuotesType = .no
        searchController.searchBar.smartDashesType = .no
        
        /// removes suggestions bar above keyboard
        //searchController.searchBar.autocorrectionType = .yes /// default .no for searchBar
        
        /// For iOS 11 and later, place the search bar in the navigation bar.
        navigationItem.searchController = searchController
        
        /// Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        //searchController.delegate = self
        
        /// to present content in current controller (without it didSelectItemAt will not work)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        
        /** Search presents a view controller by applying normal view controller presentation semantics.
         This means that the presentation moves up the view controller hierarchy until it finds the root
         view controller or one that defines a presentation context.
         */
        
        /** Specify that this view controller determines how the search controller is presented.
         The search controller should be presented modally and match the physical size of this view controller.
         */
        definesPresentationContext = true
        
        /// to fix lauout on pop with active search
        extendedLayoutIncludesOpaqueBars = true
        
        searchController.searchBar.scopeButtonTitles = SortOrder.allCases.map { $0.title }
    }

    private func fetch() {
        vcView.activityIndicator.startAnimating()
        
        service.all { [weak self] result in
            DispatchQueue.main.async {
                self?.vcView.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let items):
                    self?.handle(items: items)
                case .failure(let error):
                    self?.showErrorAlert(for: error)
                }
            }
        }
        
    }
    
    private func handle(items newItems: [Product.Item]) {
        storage.save(items: newItems) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showErrorAlert(for: error)
                } else {
                    // can be shown alert
                    print("success. items saved")
                }
            }
        }
    }
}

extension ProductsListController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select cell at \(indexPath.item)")
        
        /// dismiss keyboard if search was used and pop back
        //searchController.searchBar.resignFirstResponder()
        
        guard let item = vcView.dataSource.itemIdentifier(for: indexPath) else {
            assertionFailure()
            return
        }
        
        let detailVC = ProductDetailController(item: item)
        
        #if os(tvOS)
        present(detailVC, animated: true, completion: nil)
        #else
        navigationController?.pushViewController(detailVC, animated: true)
        #endif
    }
    
}

extension ProductsListController: UISearchResultsUpdating {
    
    /// called on UISearchController touch.
    /// called twice on cancel. searchController.isActive == true and false on each call
    func updateSearchResults(for searchController: UISearchController) {
        
        /// searchController.isActive == searchController.searchBar.isFirstResponder in this case
        if !searchController.isActive {
            return
        }
        
        guard let searchText = searchController.searchBar.text else {
            assertionFailure("set empty string to the searchBar.text insead of nil")
            return
        }
        
        let predicate: NSPredicate?
        if searchText.isEmpty {
            
            /// search become active or cancel without any text. don't need to do anything
            if vcView.fetchedResultsController.fetchRequest.predicate == nil {
                return
            }
            
            // TODO: pass reference to default predicate in fetchedResultsController.fetchRequest
            predicate = nil
        } else {
            /// or #1
            predicate = NSCompoundPredicate(type: .or, subpredicates: [
                NSPredicate(format: "\(#keyPath(Item.name)) contains[cd] %@", searchText),
                NSPredicate(format: "\(#keyPath(Item.detail)) contains[cd] %@", searchText),
                NSPredicate(format: "\(#keyPath(Item.price)) contains[cd] %@", searchText)
            ])
            /// or #2
            /// more optimized, but unsafe due argList.
            /// "OR" == "||" for NSPredicate.
            //predicate = NSPredicate(format: "(\(#keyPath(Item.name)) contains[cd] %@) || (\(#keyPath(Item.detail)) contains[cd] %@) || (\(#keyPath(Item.price)) contains[cd] %@)", searchText, searchText, searchText)
        }

        vcView.fetchedResultsController.fetchRequest.predicate = predicate
        vcView.performFetch()
    }
}

extension ProductsListController: UISearchBarDelegate {
    
    /// default for iOS 12
    //func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //    searchBar.resignFirstResponder()
    //}
    
    // TODO: clear code
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        guard let sortOrder = SortOrder(rawValue: selectedScope) else {
            assertionFailure()
            return
        }
        
        let sortDescriptors: [NSSortDescriptor]
        let sectionNameKeyPath: String?
        let headerSize: CGSize
        
        switch sortOrder {
        case .id:
            headerSize = .zero
            sectionNameKeyPath = nil
            
            let sortDescriptor1 = NSSortDescriptor(key: #keyPath(Item.id), ascending: true)
            sortDescriptors = [sortDescriptor1]
            
        case .name:
            headerSize = CGSize(width: 0, height: 44)
            sectionNameKeyPath = #keyPath(Item.section)
            
            let sortDescriptor1 = NSSortDescriptor(key: #keyPath(Item.name), ascending: true)
            let sortDescriptor2 = NSSortDescriptor(key: #keyPath(Item.id), ascending: true)
            sortDescriptors = [sortDescriptor1, sortDescriptor2]
        }
        
        (vcView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize = headerSize
        
        // TODO: reuse with fetchedResultsController
        let fetchRequest: NSFetchRequest<ProductItemDB> = ProductItemDB.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            fetchRequest.fetchBatchSize = 20
        } else {
            fetchRequest.fetchBatchSize = 10
        }
        
        //fetchRequest.shouldRefreshRefetchedObjects = false
        let context = CoreDataStack.shared.viewContext
        vcView.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                     managedObjectContext: context,
                                                                     sectionNameKeyPath: sectionNameKeyPath,
                                                                     cacheName: nil)
        
        vcView.performFetch()
        
        /// there a lite animation(not good for me) on first scope change.
        /// it is due to image placeholder.
        /// simple(but not good) fix:
        //vcView.performFetch()
        
        /// to change sorting only
        //vcView.fetchedResultsController.fetchRequest.sortDescriptors = sortDescriptors
        //vcView.performFetch()
    }
}


/// there is no CustomDebugStringConvertible bcz of error:
/// Extension of protocol 'Error' cannot have an inheritance clause
extension Error {
    var debugDescription: String {
        return String(describing: self)
    }
}

protocol ErrorPresenter {
    func showErrorAlert(with message: String)
    func showErrorAlert(for error: Error)
}
extension ErrorPresenter where Self: UIViewController {
    func showErrorAlert(with message: String) {
        /// .actionSheet easier to close
        let vc = UIAlertController(title: "Error", message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        vc.addAction(okAction)
        present(vc, animated: false, completion: nil)
    }
    
    private func defalutHandler(error: Error) {
        showErrorAlert(with: error.localizedDescription)
    }
    
    func showErrorAlert(for error: Error) {
        print(error.debugDescription)
        
        do {
            try handleAlamofireError(error)
        } catch {
            defalutHandler(error: error)
        }
    }
    
    private func handleAlamofireError(_ error: Error) throws {
        guard let afError = error as? AFError else {
            throw error
        }
        
        switch afError {
        case .sessionTaskFailed(error: let sessionError):
            
            /// internet error
            if let urlError = sessionError as? URLError {
                showErrorAlert(with: urlError.localizedDescription)
            } else {
                defalutHandler(error: sessionError)
            }
            
        default:
            defalutHandler(error: afError)
        }
    }
    
}

typealias ErrorCompletion = (Error?) -> Void

extension Data {
    var stringValue: String {
        return String(data: self, encoding: .utf8) ?? String(describing: self)
    }
}
