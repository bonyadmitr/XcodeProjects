import CoreData

@objc(NoteMO)
final class NoteMO: NSManagedObject {
    
    @NSManaged var body: String
    @NSManaged var date: Date
    
    //convenience init(context: NSManagedObjectContext, body: String, date: Date) {
    //    self.init(context: context)
    //    self.body = body
    //    self.date = date
    //}
    
    static let entityDescription: NSEntityDescription = {
        let entityDescription = NSEntityDescription(from: NoteMO.self)
        entityDescription.addProperty(NSAttributeDescription(name: #keyPath(NoteMO.body), type: .stringAttributeType))
        entityDescription.addProperty(NSAttributeDescription(name: #keyPath(NoteMO.date), type: .dateAttributeType))
        return entityDescription
    }()
}
