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
    
    struct Member{
        var login: String
        var status: Int
        init(_ login: String, _ status: Int) {
            self.login = login
            self.status = status
        }
    }
    
    
    var event: Event = Event()
    
    private var team: [Member] = []
    
    override func viewDidLoad() {
        
        teamTabel.register(UINib(nibName: "TeamMemberCell", bundle: nil), forCellReuseIdentifier: "TeamMemberCellPrototype")
        for (person, status) in event.group{
            let member = findUser(uid: person)!["login"] as! String
            if (member != currentUser()){
                team.append(Member(member, status))
            }
        }
        
        self.dateLabel.text = self.event.date
        self.titleLable.text = self.event.title
        self.startTimeLable.text = self.event.startTime
        self.endTimeLable.text = self.event.endTime
        self.descriptionTextView.text = self.event.description
        
        
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        if team.count == 0{
            teamTableHeight.constant = 0
            self.view.setNeedsLayout()
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
        cell.nicknameLable.text = "    "+team[indexPath.row].login+"    "
        if team[indexPath.row].status == 1{
            cell.nicknameLable.backgroundColor = UIColor.green
        }
        else if team[indexPath.row].status == -1{
            cell.nicknameLable.backgroundColor = UIColor.red
        }
        cell.nicknameLable.layer.masksToBounds = true
        return cell
    }
}
