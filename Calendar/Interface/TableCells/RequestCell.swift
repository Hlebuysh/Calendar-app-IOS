//
//  RequestCell.swift
//  Calendar
//
//  Created by User on 16.12.2022.
//

import UIKit

class RequestCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var timeLable: UILabel!
    
    @IBOutlet weak var agreementButton: UIButton!
    @IBOutlet weak var refusalButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        agreementButton.setTitle("", for: .normal)
        refusalButton.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
