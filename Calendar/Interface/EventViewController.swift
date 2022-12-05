//
//  EventViewController.swift
//  Calendar
//
//  Created by User on 11.11.2022.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak private var closeButton: UIButton!
    
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var startTimeLable: UILabel!
    @IBOutlet weak private var endTimeLable: UILabel!
    
    @IBOutlet weak private var titleLable: UILabel!
    
    @IBOutlet weak private var descriptionTextView: UITextView!
    
    @IBOutlet weak private var teamTabel: UITableView!
    
    @IBOutlet weak private var teamTableHeight: NSLayoutConstraint!
    
    
    private let team: [String] = ["Person 1", "Person 2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        if team.count == 0{
            teamTableHeight.constant = 0
            self.view.setNeedsLayout()
        }
        else{
            teamTabel.register(UINib(nibName: "TeamMemberCell", bundle: nil), forCellReuseIdentifier: "TeamMemberCellPrototype")
        }
    }
    @IBAction private func tapCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension EventViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberCellPrototype", for: indexPath) as! TeamMemberCell
        cell.nicknameLable.text = "    "+team[indexPath.row]+"    "
        cell.nicknameLable.layer.masksToBounds = true
        return cell
    }
}
