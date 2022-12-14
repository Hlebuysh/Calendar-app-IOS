//
//  AuthorizationViewController.swift
//  Calendar
//
//  Created by User on 08.11.2022.
//

import UIKit
import FirebaseAuth

class AuthorizationViewController: UIViewController {
    
    @IBOutlet weak private var emailField: UITextField!
    @IBOutlet weak private var passwordField: UITextField!
    
    @IBOutlet weak private var enterButton: UIButton!
    
    @IBOutlet weak private var registrationRedirectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (navigationController?.viewControllers.count == 1){
            navigationController?.setNavigationBarHidden(true, animated: false)
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil{
                    self.goToCalendar()
                }
            }
        }
    }
    
    @IBAction private func signIn(_ sender: Any) {
        self.checkLogin()
    }
    
    @IBAction private func goToRegistration(_ sender: Any) {
        performSegue(withIdentifier: "FromAuthorizationToRegisration", sender: self)
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
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (result, error) in
                if error == nil{
//                    if !result!.user.isEmailVerified {
//                        self.showAlert(message: "Подтвердите свою почту")
//                    }
//                    else{
                        self.goToCalendar()
//                    }
                }
                else{
                    self.showAlert(message: error!.localizedDescription)
                }
            }
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
            performSegue(withIdentifier: "FromAuthorizationToCalendar", sender: self)
        }
    }
}
