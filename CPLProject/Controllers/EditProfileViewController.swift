
import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate {
    
    fileprivate var profileAPI: ProfileAPI!
    var selectedProfileItem: Profile!
    var profileList: Array<Profile> = []
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var firstTxt: UITextField! { didSet { firstTxt.delegate = self } }
    @IBOutlet weak var lastTxt: UITextField! { didSet { lastTxt.delegate = self } }
    @IBOutlet weak var bankAccountTxt: UITextField! { didSet { bankAccountTxt.delegate = self } }
    
    fileprivate let firstNamespace  = ProfileAttributes.firstName.rawValue
    fileprivate let lastNamespace  = ProfileAttributes.lastName.rawValue
    fileprivate let bankAccountNamespace  = ProfileAttributes.bankAccount.rawValue
    fileprivate let profileImgNamespace  = ProfileAttributes.profileImg.rawValue

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImg.layer.cornerRadius = 60.0
        profileImg.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setup()
    }
    
    fileprivate func setup() {
        
        self.profileAPI = ProfileAPI.sharedInstance
        self.profileList = self.profileAPI.getAllProfile()
        self.setFieldValues()
    }
    
    
    fileprivate func setFieldValues() {
        let profileItem: Profile!
        if profileList.count > 0 {
            profileItem = profileList[0]
            if profileItem != nil {
                profileImg.image = UIImage(data: profileList[0].profileImg)
                firstTxt.text = profileList[0].firstName
                lastTxt.text = profileList[0].lastName
                bankAccountTxt.text = profileList[0].bankAccount
            }
        }
    }

    
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
    
        let actionSheetController = UIAlertController(title: "Please select", message: "", preferredStyle: .actionSheet)

        // Create and add the Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)

        // Create and add first option action
        let takePictureAction = UIAlertAction(title: "Gallery", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(takePictureAction)

        // Create and add a second option action
        let choosePictureAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(choosePictureAction)
        
        actionSheetController.popoverPresentationController?.sourceView = sender as UIView
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        profileImg.image = image;
        print(image.size)
    }
    
    @IBAction func updateProfileButtonTapped(_ sender: UIButton) {
        if self.profileList.count > 0 {
            let selectedProfileItem = profileList[0]
            profileAPI.updateProfile(selectedProfileItem, newProfileItemDetails:getFieldValues())
        } else {
            let newDetails = getFieldValues()
            profileAPI.saveProfile(newDetails)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func getFieldValues() -> Dictionary<String, NSObject> {

        var fieldDetails = [String: NSObject]()
        fieldDetails[firstNamespace] = firstTxt.text as NSObject?
        fieldDetails[lastNamespace] = lastTxt.text as NSObject?
        fieldDetails[bankAccountNamespace] = bankAccountTxt.text as NSObject?
        if let imageData = profileImg.image?.pngData() {
               fieldDetails[profileImgNamespace] = imageData as NSObject?
        }
        return fieldDetails
    }
    
    // MARK: Textfield delegates

    func textFieldDidEndEditing(_ textField: UITextField) {
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
