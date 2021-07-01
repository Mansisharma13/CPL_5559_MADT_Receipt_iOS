
import UIKit

class GroupItemViewController: UIViewController, UITextFieldDelegate {

    fileprivate var groupAPI: GroupAPI!
    var selectedGroupItem: Group!

    @IBOutlet weak var groupNameLabel: UITextField! { didSet { groupNameLabel.delegate = self } }

 


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    fileprivate func setup() {
        self.groupAPI = GroupAPI.sharedInstance
    }

    // MARK Actions :
    @IBAction func groupSaveButtonTapped(_ sender: UIBarButtonItem) {
        if groupNameLabel.text! != "" {
            let newDetails = getFieldValues()
            groupAPI.saveGroup(newDetails)
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: Textfield delegates

    func textFieldDidEndEditing(_ textField: UITextField) {
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    fileprivate func getFieldValues() -> Dictionary<String, NSObject> {

        var fieldDetails = [String: NSObject]()
        fieldDetails[groupName] = groupNameLabel.text as NSObject?
        fieldDetails[groupId] = "1" as NSObject
        fieldDetails[groupDescription] = "Description temp" as NSObject
        return fieldDetails
    }
}
