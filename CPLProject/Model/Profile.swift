//
//  Event.swift
//  CoreDataCRUD
//
//  Copyright © 2016 Jongens van Techniek. All rights reserved.
//

import Foundation
import CoreData

enum ProfileAttributes: String {
    case
    firstName    = "firstName",
    lastName     = "lastName",
    bankAccount  = "bankAccount",
    profileImg   = "profileImg"
}

@objc(Profile)

class Profile: NSManagedObject {
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var bankAccount: String
    @NSManaged var profileImg:Data
}
