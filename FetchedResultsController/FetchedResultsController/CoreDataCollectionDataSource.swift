//
//  CoreDataCollectionDataSource.swift
//  FetchedResultsController
//
//  Created by Bondar Yaroslav on 9/18/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataCollectionDataSource <T: NSFetchRequestResult> {
    
    private let fetchedResultsController: NSFetchedResultsController<T>
    private let fetchedResultsCollectionDelegate: FetchedResultsCollectionDelegate
    
    init(cellReuseId: String,
         headerReuseId: String,
         collectionView: UICollectionView!,
         fetchedResultsController: NSFetchedResultsController<T>)
    {
        fetchedResultsCollectionDelegate = FetchedResultsCollectionDelegate(
            cellReuseId: cellReuseId,
            headerReuseId: headerReuseId,
            collectionView: collectionView,
            fetchedResultsController: fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>
        )
        
        self.fetchedResultsController = fetchedResultsController
        fetchedResultsController.delegate = fetchedResultsCollectionDelegate
        collectionView.dataSource = fetchedResultsCollectionDelegate
    }
    
    func object(at indexPath: IndexPath) -> T {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func indexPath(forObject object: T) -> IndexPath? {
        return fetchedResultsController.indexPath(forObject: object)
    }
    
    func performFetch() {
        try? fetchedResultsController.performFetch()
    }
}

private final class FetchedResultsCollectionDelegate: NSObject {
    
    private let cellReuseId: String
    private let headerReuseId: String
    private weak var collectionView: UICollectionView!
    private weak var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    private var sectionChanges = [() -> Void]()
    private var objectChanges = [() -> Void]()
    
    init(cellReuseId: String,
         headerReuseId: String,
         collectionView: UICollectionView!,
         fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>)
    {
        self.cellReuseId = cellReuseId
        self.headerReuseId = headerReuseId
        self.collectionView = collectionView
        self.fetchedResultsController = fetchedResultsController
    }
}

extension FetchedResultsCollectionDelegate: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseId, for: indexPath)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
/// https://github.com/jessesquires/JSQDataSourcesKit/blob/develop/Source/FetchedResultsDelegate.swift
/// https://gist.github.com/nor0x/c48463e429ba7b053fff6e277c72f8ec
extension FetchedResultsCollectionDelegate: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sectionChanges.removeAll()
        objectChanges.removeAll()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let section = IndexSet(integer: sectionIndex)
        
        sectionChanges.append { [unowned self] in
            switch type {
            case .insert:
                self.collectionView.insertSections(section)
            case .delete:
                self.collectionView.deleteSections(section)
            case .move, .update:
                break
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                self.objectChanges.append { [unowned self] in
                    self.collectionView.insertItems(at: [indexPath])
                }
            }
        case .delete:
            if let indexPath = indexPath {
                self.objectChanges.append { [unowned self] in
                    self.collectionView.deleteItems(at: [indexPath])
                }
            }
        case .update:
            if let indexPath = indexPath {
                self.objectChanges.append { [unowned self] in
                    self.collectionView.reloadItems(at: [indexPath])
                }
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                self.objectChanges.append { [unowned self] in
                    self.collectionView.moveItem(at: indexPath, to: newIndexPath)
                }
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({ [weak self] in
            self?.objectChanges.forEach { $0() }
            self?.sectionChanges.forEach { $0() }
            }, completion: { [weak self] _ in
                /// check: may be don't need
                self?.reloadSupplementaryViewsIfNeeded()
        })
    }
    
    private func reloadSupplementaryViewsIfNeeded() {
        if !sectionChanges.isEmpty {
            collectionView.reloadData()
        }
    }
    
}
