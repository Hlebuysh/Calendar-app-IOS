//
//  SettingsViewController.swift
//  Calendar
//
//  Created by User on 05.12.2022.
//


import Firebase
import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var loginField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signOutButton.layer.borderWidth = 0.5
        signOutButton.layer.borderColor = UIColor.blue.cgColor
        Database.database(url: "https://calendarappforios-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users").child(Auth.auth().currentUser!.uid).child("login").observeSingleEvent(of: .value) { snapshot in
            
            
        }
    }

    @IBAction func GoToAuthorization(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }catch let error as NSError
        {
            print (error.localizedDescription)
        }
        performSegue(withIdentifier: "FromSettingsToAuthorization", sender: self)
    }
}
