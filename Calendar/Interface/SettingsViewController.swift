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
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signOutButton.layer.borderWidth = 0.5
        signOutButton.layer.borderColor = UIColor.blue.cgColor
        loginField.text = currentUser()
        notificationsSwitch.isOn = UserDefaults.standard.bool(forKey: "notifications")
    }

    @IBAction func signOutClick(_ sender: Any) {
        signOutUser(complition: goToAuthorization)
    }
    private func goToAuthorization() {
        performSegue(withIdentifier: "FromSettingsToAuthorization", sender: self)
    }
    @IBAction func loginChange(_ sender: Any) {
        if loginField.text!.count >= 5 && loginField.text! != currentUser(){
            changeButton.isEnabled = true
            return
        }
        else if loginField.text!.count == 0{
            loginField.text = currentUser()
            loginField.resignFirstResponder()
        }
        changeButton.isEnabled = false
    }
    
    @IBAction func passwordChange(_ sender: Any) {
        if passwordField.text!.count >= 6 || passwordField.text!.count == 0{
            changeButton.isEnabled = true
            return
        }
        changeButton.isEnabled = false
    }
    
    @IBAction func tapChangeButton(_ sender: Any) {
        if loginField.text! != currentUser(){
            changeLogin(newLogin: loginField.text!)
        }
        if passwordField.text!.count == 0{
            changePassword(newPassword: passwordField.text!)
            passwordField.text = ""
        }
        changeButton.isEnabled = false
    }
    
    @IBAction func switchingNotifications(_ sender: Any) {
        if !notificationsSwitch.isOn{
            UserDefaults.standard.set(false, forKey: "notifications")
            UserDefaults.standard.synchronize()
            self.tabBarController?.viewControllers?.remove(at: 3)
            return
        }
        UserDefaults.standard.set(true, forKey: "notifications")
        UserDefaults.standard.synchronize()
    }
    
}
