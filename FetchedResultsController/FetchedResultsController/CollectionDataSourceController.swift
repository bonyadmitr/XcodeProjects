//
//  CollectionDataSourceController.swift
//  FetchedResultsController
//
//  Created by Bondar Yaroslav on 9/18/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class CollectionDataSourceController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        willSet {
            newValue.delegate = self
            
            newValue.alwaysBounceVertical = true
            
            if let layout = newValue.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumLineSpacing = 1
                layout.minimumInteritemSpacing = 1
                layout.sectionInset = .init(top: 1, left: 1, bottom: 1, right: 1)
            }
        }
    }
    
    
    private lazy var dataSource = CoreDataCollectionDataSource<EventDB>(collectionView: self.collectionView,
                                                                        fetchedResultsController: EventDB.fetchedResultsController()) 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.performFetch()
        collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction private func addEvent(_ sender: UIBarButtonItem) {
        EventDB.createAndSaveNewOne()
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionDataSourceController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? EventCollectionCell else {
            return
        }
        let event = dataSource.object(at: indexPath)
        cell.fill(with: event)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let view = view as? EventCollectionHeader else {
            return
        }
        let event = dataSource.object(at: indexPath)
        view.fill(with: event)
    }
}

extension CollectionDataSourceController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(collectionView.bounds.width / 2) - 3
        return CGSize(width: width, height: width)
    }
}
