
import Foundation
import CoreData

enum ProfileAttributes: String {
    case
    firstName    = "firstName",
    lastName     = "lastName",
    bankAccount  = "bankAccount",
    profileImg   = "profileImg"
    

    static let getAll = [
        firstName,
        lastName,
        bankAccount,
        profileImg
    ]
}

@objc(Profile)

class Profile: NSManagedObject {
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var bankAccount: String
    @NSManaged var profileImg:Data
}
