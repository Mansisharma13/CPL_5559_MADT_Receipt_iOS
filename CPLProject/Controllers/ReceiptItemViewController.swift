
import UIKit

class ReceiptItemViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    fileprivate var receiptAPI: ReceiptAPI!
    var selectedReceiptItem: Receipt!
    var selectedGroupItem: Group!
    
    @IBOutlet weak var receiptNameLabel: UITextField! { didSet { receiptNameLabel.delegate = self } }
    @IBOutlet weak var receiptDescriptionLabel: UITextField! { didSet { receiptDescriptionLabel.delegate = self } }
    @IBOutlet weak var receiptDateLabel: UITextField! { didSet { receiptDateLabel.delegate = self } }
    @IBOutlet weak var receiptValueLabel: UITextField! { didSet { receiptValueLabel.delegate = self } }
    @IBOutlet weak var receiptSnapshotImg: UIImageView!
    @IBOutlet weak var receiptSnapshotBtn: UIButton!
    
    
    fileprivate let groupId  = ReceiptAttributes.groupId.rawValue
    fileprivate let groupName  = ReceiptAttributes.groupName.rawValue
    fileprivate let receiptId  = ReceiptAttributes.receiptId.rawValue
    fileprivate let receiptName  = ReceiptAttributes.receiptName.rawValue
    fileprivate let receiptDescription  = ReceiptAttributes.receiptDescription.rawValue
    fileprivate let receiptDate  = ReceiptAttributes.receiptDate.rawValue
    fileprivate let receiptValue  = ReceiptAttributes.receiptValue.rawValue
    fileprivate let receiptSnapshot  = ReceiptAttributes.receiptSnapshot.rawValue
    

    override func viewDidLoad() {
        super.viewDidLoad()
        receiptSnapshotBtn.setTitle("Take Picture", for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    fileprivate func setup() {
        self.receiptAPI = ReceiptAPI.sharedInstance
    }
    
    // MARK Actions :
    @IBAction func receiptSaveButtonTapped(_ sender: UIBarButtonItem) {
        if receiptNameLabel.text! != "" {
            let newDetails = getFieldValues()
            receiptAPI.saveReceipt(newDetails)
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func takePhotoButtonTapped(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            receiptSnapshotBtn.setTitle("Take Picture", for: .normal)
            return
        }
        receiptSnapshotBtn.setTitle("", for: .normal)
        receiptSnapshotImg.image = image;
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
       
        fieldDetails[groupId] = "1" as NSObject
        fieldDetails[groupName] = selectedGroupItem.groupName as NSObject
        fieldDetails[receiptId] = "1" as NSObject
        fieldDetails[receiptName] = receiptNameLabel.text as NSObject?
        fieldDetails[receiptDescription] = receiptDescriptionLabel.text as NSObject?
        fieldDetails[receiptDate] = receiptDateLabel.text as NSObject?
        fieldDetails[receiptValue] = receiptValueLabel.text as NSObject?
        if let imageData = receiptSnapshotImg.image?.pngData() {
               fieldDetails[receiptSnapshot] = imageData as NSObject?
        }
        return fieldDetails
    }


}
