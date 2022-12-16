//
//  ProgressViewController.swift
//  Calendar
//
//  Created by User on 16.12.2022.
//

import UIKit

class ProgressViewController: UIViewController {

    @IBOutlet weak var eventLoadProgressBar: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
    }
    
    func loadUsers(){
        getUsers(complition: loadEvents)
    }
    func loadEvents(){
        getEvents(updateProgress: updateProgress, complition: goToCalendar)
    }
    func updateProgress(progress: Float){
        eventLoadProgressBar.setProgress(progress, animated: true)
    }
    func goToCalendar(){
        performSegue(withIdentifier: "FromProgressToCalendar", sender: self)
    }

}
