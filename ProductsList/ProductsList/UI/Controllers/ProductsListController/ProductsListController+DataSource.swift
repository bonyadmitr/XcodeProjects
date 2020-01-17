import UIKit
import CoreData

// MARK: - ProductsListController+DataSource

extension ProductsListController {
    
    final class DataSource: NSObject, NSFetchedResultsControllerDelegate {
        
        typealias DataSourceType = UICollectionViewDiffableDataSource<SectionType, Item>
        
        let dataSource: DataSourceType
        
        private let collectionView: UICollectionView
        
        private lazy var fetchedResultsController: NSFetchedResultsController<Item> = SortOrder.id.fetchedResultsController
        
        init(collectionView: UICollectionView) {
            self.collectionView = collectionView
            
            /// article https://medium.com/@jamesrochabrun/uicollectionviewdiffabledatasource-and-decodable-step-by-step-6b727dd2485
            /// project from article https://github.com/jamesrochabrun/UICollectionViewDiffableDataSource
            /// ru article https://dou.ua/lenta/articles/ui-collection-view-data-source/
            /// project from ru article https://github.com/IceFloe/UICollectionViewDiffableDataSource
            dataSource = UICollectionViewDiffableDataSource<SectionType, Item>(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
                
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
            updateDataSource(animated: false)
        }
        
        func updateDataSource(animated: Bool) {
            var snapshot = NSDiffableDataSourceSnapshot<SectionType, Item>()
            
            if let sections = fetchedResultsController.sections {
                
                /// simple snapshot for one section
                if sections.count == 1 {
                    snapshot.appendSections([0])
                    snapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
                } else {
                    let sectionsArray = Array(0..<sections.count)
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
            (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize = sortOrder.headerSize
            fetchedResultsController = sortOrder.fetchedResultsController
            
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
