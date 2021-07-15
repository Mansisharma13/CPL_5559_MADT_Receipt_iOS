
import UIKit
import CoreData

enum ProfileTypes: String {
    case Profile = "Profile"
    static let getAll = [Profile]
}

class ProfileAPI {

    fileprivate let persistenceManager: PersistenceManager!
    fileprivate var mainContextInstance: NSManagedObjectContext!

    fileprivate let firstName = ProfileAttributes.firstName.rawValue
    fileprivate let lastName = ProfileAttributes.lastName.rawValue
    fileprivate let bankAccount = ProfileAttributes.bankAccount.rawValue
    fileprivate let profileImg = ProfileAttributes.profileImg.rawValue


  
    class var sharedInstance: ProfileAPI {
        struct Singleton {
            static let instance = ProfileAPI()
        }
        return Singleton.instance
    }

    init() {
        self.persistenceManager = PersistenceManager.sharedInstance
        self.mainContextInstance = persistenceManager.getMainContextInstance()
    }

    func saveProfile(_ eventDetails: Dictionary<String, AnyObject>) {

        let minionManagedObjectContextWorker: NSManagedObjectContext =
        NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = self.mainContextInstance

        //Create new Object of  entity
        let ProfileItem = NSEntityDescription.insertNewObject(forEntityName: ProfileTypes.Profile.rawValue,
            into: minionManagedObjectContextWorker) as! Profile

        //Assign field values
        for (key, value) in eventDetails {
            for attribute in ProfileAttributes.getAll {
                if (key == attribute.rawValue) {
                    ProfileItem.setValue(value, forKey: key)
                }
            }
        }
        self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        self.persistenceManager.mergeWithMainContext()
        self.postUpdateNotification()
    }

    // MARK: Update
    func updateProfile(_ profileItemToUpdate: Profile, newProfileItemDetails: Dictionary<String, AnyObject>) {

        let minionManagedObjectContextWorker: NSManagedObjectContext =
        NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = self.mainContextInstance

        //Assign field values
        for (key, value) in newProfileItemDetails {
            for attribute in ProfileAttributes.getAll {
                if (key == attribute.rawValue) {
                    profileItemToUpdate.setValue(value, forKey: key)
                }
            }
        }
        //Persist new Profile to datastore (via Managed Object Context Layer).
        self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        self.persistenceManager.mergeWithMainContext()
        self.postUpdateNotification()
    }
    
    func getAllProfile(_ sortedByDate: Bool = true, sortAscending: Bool = true) -> Array<Profile> {
        var fetchedResults: Array<Profile> = Array<Profile>()
        // Create request on  entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ProfileTypes.Profile.rawValue)
        //Execute Fetch request
        do {
            fetchedResults = try  self.mainContextInstance.fetch(fetchRequest) as! [Profile]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Profile>()
        }
        return fetchedResults
    }
    
    fileprivate func postUpdateNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileTableData"), object: nil)
    }

}
