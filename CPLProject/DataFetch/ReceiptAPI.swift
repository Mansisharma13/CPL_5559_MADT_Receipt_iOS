//Receipt

import UIKit
import CoreData


enum ReceiptTypes: String {
    case Receipt = "Receipt"
    static let getAll = [Receipt]
}

class ReceiptAPI {

    fileprivate let persistenceManager: PersistenceManager!
    fileprivate var mainContextInstance: NSManagedObjectContext!

    fileprivate let groupId = ReceiptAttributes.groupId.rawValue
    fileprivate let groupName = ReceiptAttributes.groupName.rawValue
    fileprivate let receiptId = ReceiptAttributes.receiptId.rawValue
    fileprivate let receiptName = ReceiptAttributes.receiptName.rawValue
    fileprivate let receiptDescription = ReceiptAttributes.receiptDescription.rawValue
    fileprivate let receiptDate = ReceiptAttributes.receiptDate.rawValue
    fileprivate let receiptValue = ReceiptAttributes.receiptValue.rawValue
    fileprivate let receiptSnapshot = ReceiptAttributes.receiptSnapshot.rawValue


    //Utilize Singleton pattern by instanciating EventAPI only once.
    class var sharedInstance: ReceiptAPI {
        struct Singleton {
            static let instance = ReceiptAPI()
        }
        return Singleton.instance
    }

    init() {
        self.persistenceManager = PersistenceManager.sharedInstance
        self.mainContextInstance = persistenceManager.getMainContextInstance()
    }

    func saveReceipt(_ receiptDetails: Dictionary<String, AnyObject>) {
        //Minion Context worker with Private Concurrency type.
        let minionManagedObjectContextWorker: NSManagedObjectContext =
        NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = self.mainContextInstance

        let receiptItem = NSEntityDescription.insertNewObject(forEntityName: ReceiptTypes.Receipt.rawValue,
            into: minionManagedObjectContextWorker) as! Receipt

        //Assign field values
        for (key, value) in receiptDetails {
            for attribute in ReceiptAttributes.getAll {
                if (key == attribute.rawValue) {
                    receiptItem.setValue(value, forKey: key)
                }
            }
        }

        self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        self.persistenceManager.mergeWithMainContext()
        self.postUpdateNotification()
    }

    // MARK: Read

    func getReceiptByIdGroupName(_ groupName: NSString) -> Array<Receipt> {
        var fetchedResults: Array<Receipt> = Array<Receipt>()

    
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ReceiptTypes.Receipt.rawValue)
        let findByGroupNamePredicate =
        NSPredicate(format: "groupName = %@", groupName)
        fetchRequest.predicate = findByGroupNamePredicate
        //Execute Fetch request
        do {
            fetchedResults = try self.mainContextInstance.fetch(fetchRequest) as! [Receipt]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Receipt>()
        }

        return fetchedResults
    }
    
    func getAllReceipt(_ sortedByDate: Bool = true, sortAscending: Bool = true) -> Array<Receipt> {
        var fetchedResults: Array<Receipt> = Array<Receipt>()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ReceiptTypes.Receipt.rawValue)
        do {
            fetchedResults = try  self.mainContextInstance.fetch(fetchRequest) as! [Receipt]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Receipt>()
        }
        return fetchedResults
    }

    // MARK: Delete

    func deleteReceipt(_ receiptItem: Receipt) {
        self.mainContextInstance.delete(receiptItem)
        self.persistenceManager.mergeWithMainContext()
        self.postUpdateNotification()
    }
    
    func deleteReceiptArray(_ receiptItemArray: Array<Receipt>) {
        
            for item in receiptItemArray {
                   self.mainContextInstance.delete(item)
               }
            
           // self.mainContextInstance.delete(receiptItem)
            self.persistenceManager.mergeWithMainContext()
            self.postUpdateNotification()
    }

    fileprivate func postUpdateNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateReceiptTableData"), object: nil)
    }
}
