//
//  RequestsViewController.swift
//  Calendar
//
//  Created by User on 16.12.2022.
//

import UIKit

class RequestsViewController: UITableViewController {
    
    private var sections: [[Event]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = requestsForming()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "FromRequestsToEvent" else { return }
        guard let destination = segue.destination as? EventViewController else { return }
        destination.event =
        sections[self.tableView.indexPathForSelectedRow!.section][self.tableView.indexPathForSelectedRow!.row]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section][0].date
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCellPrototype", for: indexPath) as! RequestCell
        cell.configure(
            title: sections[indexPath.section][indexPath.row].title,
            startTime: sections[indexPath.section][indexPath.row].startTime,
            endTime: sections[indexPath.section][indexPath.row].endTime,
            index: indexPath
        )
        cell.delegate = self
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FromRequestsToEvent", sender: self)
    }

}

extension RequestsViewController: RequestCellDelegate{
    func addToSchedule(with index: IndexPath) {
        agreeToEvent(eventID: sections[index.section][index.row].id)
        sections = requestsForming()
        self.tableView.reloadData()
    }
    
    func removeFromSchedule(with index: IndexPath) {
        refuseFromEvent(eventID: sections[index.section][index.row].id)
        sections = requestsForming()
        self.tableView.reloadData()
    }
}
