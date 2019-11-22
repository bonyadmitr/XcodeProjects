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
            
            self?.service.all { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let items):
                        self?.handle(items: items)
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
                    self?.handle(items: items)
                case .failure(let error):
                    print(error.debugDescription)
                }
            }
        }
    }
    
    private func handle(items newItems: [Product.Item]) {
        
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
