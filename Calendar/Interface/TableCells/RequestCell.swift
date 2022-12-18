//
//  RequestCell.swift
//  Calendar
//
//  Created by User on 16.12.2022.
//

import UIKit

protocol RequestCellDelegate: AnyObject{
    func addToSchedule(with index: IndexPath)
    func removeFromSchedule(with index: IndexPath)
}

class RequestCell: UITableViewCell {

    @IBOutlet private weak var titleLable: UILabel!
    
    @IBOutlet private weak var timeLable: UILabel!
    
    @IBOutlet weak var agreementButton: UIButton!
    @IBOutlet weak var refusalButton: UIButton!
    
    weak var delegate: RequestCellDelegate?
    
    private var index = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        agreementButton.setTitle("", for: .normal)
        refusalButton.setTitle("", for: .normal)
    }
    
    func configure(title: String, startTime: String, endTime: String, index: IndexPath){
        self.index = index
        titleLable.text = title
        timeLable.text = startTime
        if !(startTime == endTime){
            timeLable.text! += " " + endTime
        }
    }

    @IBAction func addToSchedule(_ sender: Any) {
        delegate?.addToSchedule(with: index)
    }
    @IBAction func removeFromSchedule(_ sender: Any) {
        delegate?.removeFromSchedule(with: index)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
