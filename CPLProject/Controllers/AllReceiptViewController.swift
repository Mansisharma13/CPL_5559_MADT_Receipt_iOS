
import UIKit

class AllReceiptViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var allReceiptsTableView: UITableView!
    let showProfileGroupSegueIdentifier = "showProfileGroupItemSegue"
    
    var selectedReceiptItem: Receipt!
    var receiptAPI: ReceiptAPI!
    var receiptList: Array<Receipt> = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Register for notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.updateReceiptTableData), name: .updateReceiptTableData, object: nil)

        self.receiptAPI = ReceiptAPI.sharedInstance
        receiptList.removeAll()
        self.receiptList = self.receiptAPI.getAllReceipt()
    }
    
    @objc func updateReceiptTableData() {
        refreshTableData()
    }
    
    func refreshTableData() {
        self.receiptList.removeAll(keepingCapacity: false)
        self.receiptList = self.receiptAPI.getAllReceipt()
        self.allReceiptsTableView.reloadData()
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiptList.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

          var cell = tableView.dequeueReusableCell(withIdentifier: "cellId")
              if (cell == nil) {
          cell = UITableViewCell(
          style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellId")
          }
        
        let receiptItem: Receipt!
        receiptItem = receiptList[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = receiptItem.receiptName
              return cell!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destination = segue.destination as? GroupTableViewController
        if segue.identifier == showProfileGroupSegueIdentifier {
            destination!.title = "Left Menu"
        }
    }
}


