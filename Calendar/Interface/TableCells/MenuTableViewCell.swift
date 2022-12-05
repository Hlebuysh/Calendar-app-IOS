
import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuTableCellImage: UIImageView!
    @IBOutlet weak var menuTableCellLable: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 48.0/255, green: 141.0/255, blue: 127.0/255, alpha: 1.0)
        self.selectedBackgroundView = backgroundView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
