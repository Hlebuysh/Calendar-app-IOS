//
//  EventCell.swift
//  Calendar
//
//  Created by User on 11.11.2022.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    
    @IBOutlet weak var informationField: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        informationField.backgroundColor = UIColor.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
