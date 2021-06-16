
import UIKit

/**
    The EventTable ViewController that retrieves and displays events.
*/
class GroupTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var allReceiptsTableView: UITableView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var firstLastLbl: UILabel!
    @IBOutlet var bankAccountLbl: UILabel!
        
    var profileAPI: ProfileAPI!
    var selectedProfileItem: Profile!
    var profileList: Array<Profile> = []
    
    let groupTableCellIdentifier = "groupItemCell"
    let editProfileSegueIdentifier = "editProfileSegue"
    let editGroupItemSegueIdentifier = "editGroupItemSegue"
    let receiptItemSegueSegueIdentifier = "receiptItemSegue"
    
    @IBOutlet var firstLastHeightConstraints : NSLayoutConstraint!
    @IBOutlet var bankAccountHeightConstraints : NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = 45.0
        profileImageView.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        //Register for notifications
        let notificationCenterProfile = NotificationCenter.default
        notificationCenterProfile.addObserver(self, selector: #selector(self.updateProfileTableData), name: .updateProfileTableData, object: nil)
        
        self.profileAPI = ProfileAPI.sharedInstance
        self.profileList = self.profileAPI.getAllProfile()
        let profileItem: Profile!
        if profileList.count > 0 {
            profileItem = profileList[0]
            if profileItem != nil {
                profileImageView.image = UIImage(data: profileList[0].profileImg)
                firstLastLbl.text = String(format: "%@ %@",profileList[0].firstName,profileList[0].lastName)
                bankAccountLbl.text = profileList[0].bankAccount
                
                if profileList[0].firstName.count > 0 || profileList[0].lastName.count > 0 {
                    firstLastHeightConstraints.constant = 25.0;
                } else {
                    firstLastHeightConstraints.constant = 0.0;
                }
                
                if profileList[0].bankAccount.count > 0 {
                    bankAccountHeightConstraints.constant = 25.0
                } else {
                    bankAccountHeightConstraints.constant = 0.0
                }
            }
        }
        allReceiptsTableView.layer.borderWidth = 0.5;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupCell =
        tableView.dequeueReusableCell(withIdentifier: groupTableCellIdentifier, for: indexPath) as! GroupTableViewCell
        groupCell.groupName.text = "Receipt Group"
        return groupCell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destination = segue.destination as? EditProfileViewController
        if segue.identifier == editProfileSegueIdentifier {
            destination!.title = "Profile"
        }
    }

    @objc func updateProfileTableData() {
        let profileItem: Profile!
        if profileList.count > 0 {
            profileItem = profileList[0]
            if profileItem != nil {
                profileImageView.image = UIImage(data: profileList[0].profileImg)
                firstLastLbl.text = String(format: "%@ %@",profileList[0].firstName,profileList[0].lastName)
                bankAccountLbl.text = profileList[0].bankAccount
                
                if profileList[0].firstName.count > 0 || profileList[0].lastName.count > 0 {
                    firstLastHeightConstraints.constant = 25.0;
                } else {
                    firstLastHeightConstraints.constant = 0.0;
                }
                
                if profileList[0].bankAccount.count > 0 {
                    bankAccountHeightConstraints.constant = 25.0
                } else {
                    bankAccountHeightConstraints.constant = 0.0
                }
            }
        }
    }
}

extension Notification.Name {
    static let updateProfileTableData = Notification.Name(rawValue: "updateProfileTableData")
}
