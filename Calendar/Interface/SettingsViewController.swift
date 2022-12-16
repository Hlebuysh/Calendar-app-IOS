//
//  SettingsViewController.swift
//  Calendar
//
//  Created by User on 05.12.2022.
//


import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var loginField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signOutButton.layer.borderWidth = 0.5
        signOutButton.layer.borderColor = UIColor.blue.cgColor
        loginField.text = currentUser()
    }

    @IBAction func signOutClick(_ sender: Any) {
        signOutUser(complition: goToAuthorization)
    }
    private func goToAuthorization() {
        performSegue(withIdentifier: "FromSettingsToAuthorization", sender: self)
    }
}
