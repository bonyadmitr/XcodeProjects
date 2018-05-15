//
//  ViewController.swift
//  CoreDataMulti
//
//  Created by Bondar Yaroslav on 29/10/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<PostDB> = {
        let fetchRequest: NSFetchRequest<PostDB> = PostDB.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(key: #keyPath(PostDB.id), ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: #keyPath(PostDB.body), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor2]
        fetchRequest.fetchBatchSize = 20
//        fetchRequest.relationshipKeyPathsForPrefetching = [#keyPath(PostDB.id)]
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: #keyPath(PostDB.userId), cacheName: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        PostService.shared.getAll(success: { posts in
//            CoreDataStack.shared.persistentContainer.performBackgroundTask { context in
//                posts.forEach { _ = $0.postDB(for: context)}
//                try? context.save()
//            }
//        }, failed: { error in
//            print(error.localizedDescription)
//        })
        
        CoreDataStack.shared.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            
            CoreDataStack.shared.persistentContainer.performBackgroundTask { context in
                //            context.automaticallyMergesChangesFromParent = true
                for i in 1...10 {
                    for j in 1...10 {
                        let post = PostDB(context: context)
                        post.id = Int64(i)
                        post.userId = Int64(i)
                        post.title = "Title \(i)\(j)"
                        post.body = "Body \(i)\(j)"
                    }
                    try? context.save()
                }
            }
        }

        
        
        //        let context = fetchedResultsController.managedObjectContext
        //        for i in 1...1000 {
        //            for j in 1...1000 {
        //                let post = PostDB(context: context)
        //                post.id = Int64(i)
        //                post.userId = Int64(i)
        //                post.title = "Title \(i)\(j)"
        //                post.body = "Body \(i)\(j)"
        //            }
        //            try? context.save()
        //        }
        
        
        //        CoreDataStack.shared.saveContext()
        
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = post.body
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController.sectionIndexTitles
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController.section(forSectionIndexTitle: title, at: index)
    }
}


//tableView.tableFooterView = getInfinityView()
//}
//
//func getInfinityView() -> UIView {
//    let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
//    let activity = UIActivityIndicatorView(frame: rect)
//    activity.startAnimating()
//    activity.color = UIColor.red
//    return activity
//}
//
//private var page = 1
//func loadMore() {
//    if isLoadingMore {
//        return
//    }
//    isLoadingMore = true
//    DispatchQueue.main.asyncAfter(deadline: globalPullToRefreshDelay) {
//        self.page += 1
//        if self.page <= 5 {
//            self.dataSource.someArray.append(1111)
//            /// stopLoadingMore
//        } else {
//            /// noticeNoMoreData
//            self.tableView.tableFooterView = nil
//        }
//        self.isLoadingMore = false
//    }
//}
//extension ViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let currentOffset = scrollView.contentOffset.y
//        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
//        let infinity = tableView.tableFooterView?.bounds.height ?? 0
//        let deltaOffset = maximumOffset - currentOffset - infinity
//
//        if deltaOffset <= 0 {
////            loadMore()
//        }
//    }
//}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .update, .move:
            tableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        }
    }
}

