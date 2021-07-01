//
//  EventAPI.swift
//  CoreDataCRUD
//
//  Copyright © 2016 Jongens van Techniek. All rights reserved.
//

import UIKit
import CoreData

/**
    Event API contains the endpoints to Create/Read/Update/Delete Events.
*/

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

        //Create new Object of Event entity
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
        //Save current work on Minion workers
        self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)

        //Save and merge changes from Minion workers with Main context
        self.persistenceManager.mergeWithMainContext()

        //Post notification to update datasource of a given Viewcontroller/UITableView
        self.postUpdateNotification()
    }

    // MARK: Read

    func getGroupById(_ eventId: NSString) -> Array<Group> {
        var fetchedResults: Array<Group> = Array<Group>()

        // Create request on Event entity
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

        //Create sort descriptor to sort retrieved Events by Date, ascending
//        if sortedByDate {
//            let sortDescriptor = NSSortDescriptor(key: dateNamespace,
//                ascending: sortAscending)
//            let sortDescriptors = [sortDescriptor]
//            fetchRequest.sortDescriptors = sortDescriptors
//        }

        //Execute Fetch request
        do {
            fetchedResults = try  self.mainContextInstance.fetch(fetchRequest) as! [Group]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Group>()
        }
        return fetchedResults
    }
    
    // MARK: Update
//    func updateEvent(_ eventItemToUpdate: Event, newEventItemDetails: Dictionary<String, AnyObject>) {
//
//        let minionManagedObjectContextWorker: NSManagedObjectContext =
//        NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
//        minionManagedObjectContextWorker.parent = self.mainContextInstance
//
//        //Assign field values
//        for (key, value) in newEventItemDetails {
//            for attribute in EventAttributes.getAll {
//                if (key == attribute.rawValue) {
//                    eventItemToUpdate.setValue(value, forKey: key)
//                }
//            }
//        }
//        //Persist new Event to datastore (via Managed Object Context Layer).
//        self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
//        self.persistenceManager.mergeWithMainContext()
//        self.postUpdateNotification()
//    }

    // MARK: Delete

    func deleteGroup(_ groupItem: Group) {
        self.mainContextInstance.delete(groupItem)
        self.persistenceManager.mergeWithMainContext()
        self.postUpdateNotification()
    }

    fileprivate func postUpdateNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateGroupTableData"), object: nil)
    }

}
