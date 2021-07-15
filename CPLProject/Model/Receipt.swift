
import Foundation
import CoreData

enum ReceiptAttributes: String {
    case
    groupId = "groupId",
    groupName = "groupName",
    receiptId   = "receiptId",
    receiptName = "receiptName",
    receiptDescription  = "receiptDescription",
    receiptDate = "receiptDate",
    receiptValue = "receiptValue",
    receiptSnapshot = "receiptSnapshot"
    

    static let getAll = [
        groupId,
        groupName,
        receiptId,
        receiptName,
        receiptDescription,
        receiptDate,
        receiptValue,
        receiptSnapshot
    ]
}

@objc(Receipt)

class Receipt: NSManagedObject {
    @NSManaged var groupId: String
    @NSManaged var groupName: String
    @NSManaged var receiptId: String
    @NSManaged var receiptName: String
    @NSManaged var receiptDescription: String
    @NSManaged var receiptDate: String
    @NSManaged var receiptValue: String
    @NSManaged var receiptSnapshot:Data
}
