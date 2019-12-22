import UIKit
import CoreData

// MARK: - ProductsListController+DataSource

extension ProductsListController {
    
    final class DataSource: NSObject, NSFetchedResultsControllerDelegate {
        
        typealias DataSourceType = UICollectionViewDiffableDataSource<SectionType, Item>
        
        private let collectionView: UICollectionView
        let dataSource: DataSourceType
        //var fetchedResultsController: NSFetchedResultsController<Item>
        
        
        lazy var fetchedResultsController: NSFetchedResultsController<Item> = {
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
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
        
        init(collectionView: UICollectionView) {
            self.collectionView = collectionView
            
            /// article https://medium.com/@jamesrochabrun/uicollectionviewdiffabledatasource-and-decodable-step-by-step-6b727dd2485
            /// project from article https://github.com/jamesrochabrun/UICollectionViewDiffableDataSource
            /// ru article https://dou.ua/lenta/articles/ui-collection-view-data-source/
            /// project from ru article https://github.com/IceFloe/UICollectionViewDiffableDataSource
            dataSource = UICollectionViewDiffableDataSource<SectionType, Item>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell in
                
                // TODO: check weak self
                
                guard let cell = collectionView.dequeue(cell: Cell.self, for: indexPath) else {
                    assertionFailure()
                    return UICollectionViewCell()
                }
                cell.setup(for: item)
                return cell
            }
            
            super.init()
            fetchedResultsController.delegate = self
            
            dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView in
                
                guard let view = collectionView.dequeue(supplementaryView: TitleSupplementaryView.self, kind: kind, for: indexPath) else {
                    assertionFailure()
                    return UICollectionReusableView()
                }
                
                view.titleLabel.text = self.fetchedResultsController.sections?[indexPath.section].name

                return view
            }
            
            
        }
        
        func performFetch() {
            try? fetchedResultsController.performFetch()
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
                        let items = (0..<section.numberOfObjects).map { itemIndex -> Item in
                            let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                            return fetchedResultsController.object(at: indexPath)
                        }
                        snapshot.appendItems(items, toSection: sectionIndex)
                    }
                }
                
            }
            
            dataSource.apply(snapshot, animatingDifferences: animated)
        }
        
        func update(with searchText: String) {
            let predicate: NSPredicate?
            if searchText.isEmpty {
                
                /// search become active or cancel without any text. don't need to do anything
                if fetchedResultsController.fetchRequest.predicate == nil {
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

            fetchedResultsController.fetchRequest.predicate = predicate
        }
        
        func update(with sortOrder: SortOrder) {
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
            
            // TODO: maybe needs refactor
            (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize = headerSize
            
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
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                         managedObjectContext: context,
                                                                         sectionNameKeyPath: sectionNameKeyPath,
                                                                         cacheName: nil)
            
            /// to change sorting only
            //fetchedResultsController.fetchRequest.sortDescriptors = sortDescriptors
        }
        
        //func deleteAllItems(animated: Bool) {
        //    var snapshot = NSDiffableDataSourceSnapshot<SectionType, Item>() //dataSource.snapshot()
        //    snapshot.appendSections([0])
        //    dataSource.apply(snapshot, animatingDifferences: animated)
        //}
        
        // MARK: - NSFetchedResultsControllerDelegate
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            assert(fetchedResultsController == controller)
            updateDataSource(animated: true)
        }
    }

    
}
