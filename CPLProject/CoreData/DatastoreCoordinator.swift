
import Foundation
import CoreData

/**
    Core Data persistenceStore coordinator that will for example create the SQlite database.
*/
class DatastoreCoordinator: NSObject {

    fileprivate let objectModelName = "CPLProject"
    fileprivate let objectModelExtension = "momd"
    fileprivate let dbFilename = "SingleViewCoreData.sqlite"

    override init() {
        super.init()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    //
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.objectModelName, withExtension: self.objectModelExtension)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    //
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.dbFilename)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            abort()
        }

        return coordinator
    }()
}
