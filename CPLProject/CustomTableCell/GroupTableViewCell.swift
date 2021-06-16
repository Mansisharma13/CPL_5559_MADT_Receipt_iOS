
import UIKit

class GroupTableViewCell: UITableViewCell {


    @IBOutlet weak var groupName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
