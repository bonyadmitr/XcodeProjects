import UIKit
import CoreData

final class ExpressionTableController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    /// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html
    /// The sectionNameKeyPath property must also be an NSSortDescriptor instance.
    /// The NSSortDescriptor must be the first descriptor in the array passed to the fetch request.
    lazy var fetchedResultsController: NSFetchedResultsController<NSDictionary> = {
        let fetchRequest: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "EventDB")
        
        let sortDescriptor1 = NSSortDescriptor(key: #keyPath(EventDB.date), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor1]
        
        /// http://macbug.ru/cocoa/coredatafetch
        /// https://developer.apple.com/documentation/foundation/nsexpression/1413747-init
        /// http://www.cimgf.com/2015/06/25/core-data-and-aggregate-fetches-in-swift/
        /// https://habr.com/ru/post/265319/
        let keyPathExpression = NSExpression(forKeyPath: #keyPath(EventDB.date))
        let minExpression = NSExpression(forFunction: "max:", arguments: [keyPathExpression])
        
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "someDictKey" //key in .dictionaryResultType
        expressionDescription.expression = minExpression
        expressionDescription.expressionResultType = .dateAttributeType
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        //NSExpression(expressionType: NSExpression.ExpressionType.evaluatedObject)
        
        //fetchRequest.relationshipKeyPathsForPrefetching = [#keyPath(PostDB.id)]
        let context = CoreDataStack.shared.mainContext
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: #keyPath(EventDB.date), cacheName: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 'NSFetchedResultsController does not support both change tracking and fetch request's with NSDictionaryResultType'
        //fetchedResultsController.delegate = self
        performFetch()
    }
    
    private func performFetch() {
        try? fetchedResultsController.performFetch()
        tableView.reloadData()
    }
    
    @IBAction private func addEvent(_ sender: UIBarButtonItem) {
        EventDB.createAndSaveNewOne()
    }
}

extension ExpressionTableController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
    }
}

extension ExpressionTableController: UITableViewDelegate {
    
    //    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    //        return fetchedResultsController.sectionIndexTitles
    //    }
    //
    //    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
    //        return fetchedResultsController.section(forSectionIndexTitle: title, at: index)
    //    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EventCell else {
            return
        }
        let event = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = String(describing: event["someDictKey"])
//        cell.fill(with: event)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        /// weak?
//        let action = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _, indexPath in
//            let event = self?.fetchedResultsController.object(at: indexPath)
//            event?.delete()
//        }
//        return [action]
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
}

extension ExpressionTableController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
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
