
import UIKit
import CoreData


enum GroupTypes: String {
    case Group = "Group"
    static let getAll = [Group]
}

class GroupAPI {

    fileprivate let persistenceManager: PersistenceManager!
    fileprivate var mainContextInstance: NSManagedObjectContext!

    fileprivate let groupId = GroupAttributes.groupId.rawValue
    fileprivate let groupName = GroupAttributes.groupName.rawValue
    fileprivate let groupDescription = GroupAttributes.groupDescription.rawValue


    //Utilize Singleton pattern by instanciating EventAPI only once.
    class var sharedInstance: GroupAPI {
        struct Singleton {
            static let instance = GroupAPI()
        }
        return Singleton.instance
    }

    init() {
        self.persistenceManager = PersistenceManager.sharedInstance
        self.mainContextInstance = persistenceManager.getMainContextInstance()
    }

    func saveGroup(_ eventDetails: Dictionary<String, AnyObject>) {
        //Minion Context worker with Private Concurrency type.
        let minionManagedObjectContextWorker: NSManagedObjectContext =
        NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = self.mainContextInstance

       
        let eventItem = NSEntityDescription.insertNewObject(forEntityName: GroupTypes.Group.rawValue,
            into: minionManagedObjectContextWorker) as! Group

        //Assign field values
        for (key, value) in eventDetails {
            for attribute in GroupAttributes.getAll {
                if (key == attribute.rawValue) {
                    eventItem.setValue(value, forKey: key)
                }
            }
        }
   
        self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        self.persistenceManager.mergeWithMainContext()
        self.postUpdateNotification()//update table
    }

    // MARK: Read

    func getGroupById(_ eventId: NSString) -> Array<Group> {
        var fetchedResults: Array<Group> = Array<Group>()

      
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: GroupTypes.Group.rawValue)


        //Execute Fetch request
        do {
            fetchedResults = try self.mainContextInstance.fetch(fetchRequest) as! [Group]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Group>()
        }

        return fetchedResults
    }
    
    func getAllGroup(_ sortedByDate: Bool = true, sortAscending: Bool = true) -> Array<Group> {
        var fetchedResults: Array<Group> = Array<Group>()

        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: GroupTypes.Group.rawValue)

        //Execute Fetch request
        do {
            fetchedResults = try  self.mainContextInstance.fetch(fetchRequest) as! [Group]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Group>()
        }
        return fetchedResults
    }

    // MARK: Delete

    func deleteGroup(_ groupItem: Group) {
        self.mainContextInstance.delete(groupItem)
        self.persistenceManager.mergeWithMainContext()
        self.postUpdateNotification()
    }
//To refeash Table
    fileprivate func postUpdateNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateGroupTableData"), object: nil)
    }
    
    // Create Default Group
    func saveGroup(_ groupTitle: String?) {
        
        //Minion Context worker with Private Concurrency type.
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = self.mainContextInstance
        
        //Create new Object of Event entity
        let groupItem = NSEntityDescription.insertNewObject(forEntityName: GroupTypes.Group.rawValue,
                                                            into: minionManagedObjectContextWorker) as! Group
        
        groupItem.groupId = "1"
        groupItem.groupName = groupTitle!
        groupItem.groupDescription = "Default group"
        self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        self.persistenceManager.mergeWithMainContext()
        self.postUpdateNotification()
    }
    
    func getGroupName(_ groupName: NSString) -> Array<Group> {
        var fetchedResults: Array<Group> = Array<Group>()

    
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: GroupTypes.Group.rawValue)
        let findByGroupNamePredicate =
        NSPredicate(format: "groupName = %@", groupName)
        fetchRequest.predicate = findByGroupNamePredicate
        //Execute Fetch request
        do {
            fetchedResults = try self.mainContextInstance.fetch(fetchRequest) as! [Group]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Group>()
        }

        return fetchedResults
    }
}
