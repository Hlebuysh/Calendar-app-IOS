//
//  EventViewController.swift
//  Calendar
//
//  Created by User on 11.11.2022.
//

import UIKit
import Firebase

class EventViewController: UIViewController {

    @IBOutlet weak private var closeButton: UIButton!
    
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var startTimeLable: UILabel!
    @IBOutlet weak private var endTimeLable: UILabel!
    
    @IBOutlet weak private var titleLable: UILabel!
    
    @IBOutlet weak private var descriptionTextView: UITextView!
    
    @IBOutlet weak private var teamTabel: UITableView!
    
    @IBOutlet weak private var teamTableHeight: NSLayoutConstraint!
    
    
    var event: Event = Event()
    
    private var team: [String] = []
    
    override func viewDidLoad() {
        
        teamTabel.register(UINib(nibName: "TeamMemberCell", bundle: nil), forCellReuseIdentifier: "TeamMemberCellPrototype")
        for (person, status) in event.group{
            Database.database(url: "https://calendarappforios-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users").child(person as! String).child("login").observeSingleEvent(of: .value) { snapshot in
//                print(snapshot)
//                print(snapshot.value)
                self.team.append(snapshot.value as! String)
                self.team.sort()
                if self.team.count > 0{
                    self.teamTableHeight.constant = 60
                    self.view.setNeedsLayout()
                }
                self.teamTabel.reloadData()
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
        cell.nicknameLable.text = "    "+team[indexPath.row]+"    "
        cell.nicknameLable.layer.masksToBounds = true
        return cell
    }
}
