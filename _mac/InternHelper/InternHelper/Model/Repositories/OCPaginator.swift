//
//  OCPaginator.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 20.06.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import Foundation
import PromiseKit
// TODO: - Can be upgraded


// MARK: - OCPaginatorDelegate
protocol OCPaginatorDelegate: class {
    func willUpdateElements()
    func didUpdateElements()
    func didGetNewElementsWithIndexPaths(indexPaths: [NSIndexPath])
    func didGetTotalNumberOfElemenets()
}


// MARK: - OCPaginator
class OCPaginator <T: OCEntity> {
    
    // MARK: - Properties
    var filter : [String : AnyObject]? {
        didSet {
            offset = 0
            array = []
        }
    }
    
    var offset = 0
    var limit = 10
    var total = 0
    
    let repository: OCRepository<T>
    var array : [T] = []
    weak var delegate : OCPaginatorDelegate?
    
    
    // MARK: - Life cycle
    init(repository: OCRepository<T>, delegate: OCPaginatorDelegate) {
        self.repository = repository
        self.delegate = delegate
        self.repository.count().then { count -> Void in
            self.total = count
            if let delegate = self.delegate {
                delegate.didGetTotalNumberOfElemenets()
            }
        }
    }

    
    // MARK: - Methods
    func getNext() {

        var step = limit
        if self.limit + self.offset > self.total {
            step = self.total - self.offset
        }
        
        var finalFiler = filter ?? [:]
        finalFiler["offset"] = offset
        finalFiler["limit"] = limit

        repository.findAll(finalFiler).then { (array: [T]) -> Void in
            if let delegate = self.delegate {
                
                var indexPathsArray : [NSIndexPath] = []
                
                for i in 0..<step {
                    let indexPath = NSIndexPath(forItem: self.offset + i, inSection: 0)
                    indexPathsArray.append(indexPath)
                }
                
                delegate.willUpdateElements()
                delegate.didGetNewElementsWithIndexPaths(indexPathsArray)
            }
            self.array.appendContentsOf(array)
            self.offset += step
        }.always {
            if let delegate = self.delegate {
                delegate.didUpdateElements()
            }
        }
    }
}