
import UIKit

/**
    The EventTable ViewController that retrieves and displays events.
*/
class GroupTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var allReceiptsTableView: UITableView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var firstLastLbl: UILabel!
    @IBOutlet var bankAccountLbl: UILabel!
    
    
    var groupList: Array<Group> = []
    var selectedGroupItem: Group!
    var groupAPI: GroupAPI!
    
    var profileAPI: ProfileAPI!
    var selectedProfileItem: Profile!
    var profileList: Array<Profile> = []
    
    var receiptAPI: ReceiptAPI!
    var receiptList: Array<Receipt> = []
    
    let groupTableCellIdentifier = "groupItemCell"
    let editProfileSegueIdentifier = "editProfileSegue"
    let editGroupItemSegueIdentifier = "editGroupItemSegue"
    let receiptItemSegueSegueIdentifier = "receiptItemSegue"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = 45.0
        profileImageView.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        //Register for notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.updateGroupTableData), name: .updateGroupTableData, object: nil)
        let notificationCenterProfile = NotificationCenter.default
        notificationCenterProfile.addObserver(self, selector: #selector(self.updateProfileTableData), name: .updateProfileTableData, object: nil)
        
        self.receiptAPI = ReceiptAPI.sharedInstance
        self.profileAPI = ProfileAPI.sharedInstance
        self.profileList = self.profileAPI.getAllProfile()
        let profileItem: Profile!
        if profileList.count > 0 {
            profileItem = profileList[0]
            if profileItem != nil {
                profileImageView.image = UIImage(data: profileList[0].profileImg)
                firstLastLbl.text = String(format: "%@ %@",profileList[0].firstName,profileList[0].lastName)
                bankAccountLbl.text = profileList[0].bankAccount
            }
        }

        self.groupAPI = GroupAPI.sharedInstance
        self.groupList = self.groupAPI.getAllGroup()
        allReceiptsTableView.layer.borderWidth = 0.5;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupCell =
        tableView.dequeueReusableCell(withIdentifier: groupTableCellIdentifier, for: indexPath) as! GroupTableViewCell
        let groupItem: Group!
        groupItem = groupList[(indexPath as NSIndexPath).row]
        groupCell.groupName.text = groupItem.groupName
        return groupCell
    }
    // MARK: - Table edit mode

        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

         func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                var singleItem : NSString = ""
                singleItem = groupList[(indexPath as NSIndexPath).row].groupName as NSString
                let list = receiptAPI.getReceiptByIdGroupName(singleItem)
                receiptAPI.deleteReceiptArray(list);
                groupAPI.deleteGroup(groupList[(indexPath as NSIndexPath).row])
            }
        }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destination = segue.destination as? GroupItemViewController
        if segue.identifier == editGroupItemSegueIdentifier {
            destination!.title = "Add Receipt Group"
        } else if segue.identifier == editProfileSegueIdentifier {
           let destination = segue.destination as? EditProfileViewController
            destination!.title = "Profile"
        } else if segue.identifier == receiptItemSegueSegueIdentifier {
            let destination = segue.destination as? ReceiptTableViewController
            let selectedGroupItem: Group!
            selectedGroupItem = groupList[(allReceiptsTableView.indexPathForSelectedRow! as NSIndexPath).row] as Group
            destination!.selectedGroupItem = selectedGroupItem
            
        }
    }


    // MARK: -
    
    @objc func updateGroupTableData() {
        refreshTableData()
    }
    
    /** Refresh table data */
    func refreshTableData() {
        self.groupList.removeAll(keepingCapacity: false)
        self.groupList = self.groupAPI.getAllGroup()
        self.allReceiptsTableView.reloadData()
        //self.title = String(format: "Upcoming events (%i)", self.groupList.count)
    }
    
    // To update Profile
    @objc func updateProfileTableData() {
        let profileItem: Profile!
        if profileList.count > 0 {
            profileItem = profileList[0]
            if profileItem != nil {
                profileImageView.image = UIImage(data: profileList[0].profileImg)
                firstLastLbl.text = String(format: "%@ %@",profileList[0].firstName,profileList[0].lastName)
                bankAccountLbl.text = profileList[0].bankAccount
            }
        }
    }
    
    
}

extension Notification.Name {
    static let updateGroupTableData = Notification.Name(rawValue: "updateGroupTableData")
    static let updateProfileTableData = Notification.Name(rawValue: "updateProfileTableData")
}
