
import UIKit

class ReceiptItemViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    fileprivate var receiptAPI: ReceiptAPI!
    var selectedReceiptItem: Receipt!
    var selectedGroupItem: Group!
    
    @IBOutlet weak var receiptNameTxt: UITextField! { didSet { receiptNameTxt.delegate = self } }
    @IBOutlet weak var receiptDescriptionTxt: UITextView! { didSet { receiptDescriptionTxt.delegate = self } }
    @IBOutlet weak var receiptDateTxt: UITextField! { didSet { receiptDateTxt.delegate = self } }
    @IBOutlet weak var receiptValueTxt: UITextField! { didSet { receiptValueTxt.delegate = self } }
    @IBOutlet weak var receiptSnapshotImg: UIImageView!
    @IBOutlet weak var receiptSnapshotBtn: UIButton!
    
    //DB :
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
        receiptDescriptionTxt.layer.borderWidth = 1;
        receiptDescriptionTxt.layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0).cgColor
        receiptDescriptionTxt.layer.cornerRadius = 5;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    fileprivate func setup() {
        self.receiptAPI = ReceiptAPI.sharedInstance
    }
    
    // MARK Actions :
    @IBAction func receiptSaveButtonTapped(_ sender: UIBarButtonItem) {
        if receiptNameTxt.text! != "" {
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
            imagePicker.allowsEditing = true
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
    
    // MARK: Textfield & Textview delegates
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 50    // 50 Limit Value
    }

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
        fieldDetails[receiptName] = receiptNameTxt.text as NSObject?
        fieldDetails[receiptDescription] = receiptDescriptionTxt.text as NSObject?
        fieldDetails[receiptDate] = receiptDateTxt.text as NSObject?
        fieldDetails[receiptValue] = receiptValueTxt.text as NSObject?
        if let imageData = receiptSnapshotImg.image?.pngData() {
               fieldDetails[receiptSnapshot] = imageData as NSObject?
        }
        return fieldDetails
    }


}
