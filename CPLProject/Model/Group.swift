//
//  Event.swift
//  CoreDataCRUD
//
//  Copyright © 2016 Jongens van Techniek. All rights reserved.
//

import Foundation
import CoreData

enum GroupAttributes: String {
    case
    groupId    = "groupId",
    groupName      = "groupName",
    groupDescription      = "groupDescription"
    

    static let getAll = [
        groupId,
        groupName,
        groupDescription
    ]
}

@objc(Group)

/**
    The Core Data Model: Event
*/
class Group: NSManagedObject {
    @NSManaged var groupId: String
    @NSManaged var groupName: String
    @NSManaged var groupDescription: String
}
