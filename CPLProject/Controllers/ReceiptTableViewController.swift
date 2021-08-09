
import UIKit

class ReceiptTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedReceiptItem: Receipt!
    var receiptAPI: ReceiptAPI!
    var receiptList: Array<Receipt> = []
    
    var selectedGroupItem: Group!
    var groupAPI: GroupAPI!
    
    @IBOutlet var totalLbl: UILabel!
    
    @IBOutlet var receiptsTableView: UITableView!
    let receiptTableCellIdentifier = "receiptItemCell"
    let addReceiptItemSegueIdentifier = "addReceiptItemSegue"
    var receiptTotal : NSInteger = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    fileprivate func setup() {
        self.groupAPI = GroupAPI.sharedInstance
        if(self.selectedGroupItem != nil) {
            setFieldValues()
        }
    }
    func setFieldValues() {
        self.title = selectedGroupItem.groupName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Register for notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.updateReceiptTableData), name: .updateReceiptTableData, object: nil)

        self.receiptAPI = ReceiptAPI.sharedInstance
        receiptList.removeAll()
        self.receiptList = self.receiptAPI.getReceiptByIdGroupName(selectedGroupItem.groupName as NSString)
        receiptTotal = 0;
    }
    
    @objc func updateReceiptTableData() {
        refreshTableData()
    }
    
    func refreshTableData() {
        receiptTotal = 0;
        self.receiptList.removeAll(keepingCapacity: false)
        self.receiptList = self.receiptAPI.getReceiptByIdGroupName(selectedGroupItem.groupName as NSString)
        self.receiptsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiptList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let receiptCell =
        tableView.dequeueReusableCell(withIdentifier: receiptTableCellIdentifier, for: indexPath) as! ReceiptTableViewCell
         let receiptItem: Receipt!
        receiptItem = receiptList[(indexPath as NSIndexPath).row]
        receiptCell.receiptName.text = receiptItem.receiptName
        if receiptItem.receiptValue != "" {
            receiptTotal = receiptTotal + Int(receiptItem.receiptValue)!
        }
        totalLbl.text = NSString(format: "Total = %d", receiptTotal) as String
        return receiptCell
    }
    
    // MARK: - Table edit mode

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            receiptAPI.deleteReceipt(receiptList[(indexPath as NSIndexPath).row])
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destination = segue.destination as? ReceiptItemViewController
        if segue.identifier == addReceiptItemSegueIdentifier {
            destination!.title = "Add Receipt"
            destination!.selectedGroupItem = selectedGroupItem
        }
    }
}

extension Notification.Name {
    static let updateReceiptTableData = Notification.Name(rawValue: "updateReceiptTableData")
}
