//
//  AuthorizationViewController.swift
//  Calendar
//
//  Created by User on 08.11.2022.
//

import UIKit
//import FirebaseAuth

class AuthorizationViewController: UIViewController {
    
    @IBOutlet weak private var emailField: UITextField!
    @IBOutlet weak private var passwordField: UITextField!
    
    @IBOutlet weak private var enterButton: UIButton!
    
    @IBOutlet weak private var registrationRedirectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (navigationController?.viewControllers.count == 1){
            navigationController?.setNavigationBarHidden(true, animated: false)
            didSignIn(complition: goToCalendar)
        }
    }
    
    @IBAction private func signIn(_ sender: Any) {
        self.checkLogin()
    }
    
    @IBAction private func goToRegistration(_ sender: Any) {
        performSegue(withIdentifier: "FromAuthorizationToRegistration", sender: self)
    }
}

extension AuthorizationViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (emailField.isFirstResponder){
            passwordField.becomeFirstResponder()
        }else{
            self.checkLogin()
        }
        return true
    }
}


extension AuthorizationViewController{
    private func checkLogin(){
        if (!emailField.text!.isEmpty && !passwordField.text!.isEmpty){
            signInUser(email: emailField.text!, password: passwordField.text!, complition: goToCalendar)
        }
        else{
            self.showAlert(message: "Запоните все поля")
        }
    }
    private func goToCalendar(){
        navigationController?.setNavigationBarHidden(true, animated: false)
        if navigationController?.viewControllers.count ?? 0 > 1{
            navigationController?.popViewController(animated: true)
        }
        else{
            performSegue(withIdentifier: "FromAuthorizationToProgress", sender: self)
        }
    }
}
