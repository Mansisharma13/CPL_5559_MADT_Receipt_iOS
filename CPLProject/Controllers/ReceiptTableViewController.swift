
import UIKit

class ReceiptTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedReceiptItem: Receipt!
    var receiptAPI: ReceiptAPI!
    var receiptList: Array<Receipt> = []
    
    var selectedGroupItem: Group!
    var groupAPI: GroupAPI!
    
    @IBOutlet var receiptsTableView: UITableView!
    let receiptTableCellIdentifier = "receiptItemCell"
    
    let addReceiptItemSegueIdentifier = "addReceiptItemSegue"

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
    }
    
    @objc func updateReceiptTableData() {
        refreshTableData()
    }
    
    func refreshTableData() {
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
        return receiptCell
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
