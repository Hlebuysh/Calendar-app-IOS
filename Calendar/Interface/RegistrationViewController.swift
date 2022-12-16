//
//  RegistrationViewController.swift
//  Calendar
//
//  Created by User on 08.11.2022.
//

import UIKit
//import Firebase

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak private var loginField: UITextField!
    @IBOutlet weak private var passowrdField: UITextField!
    @IBOutlet weak private var emailField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak private var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        self.checkUser()
    }
    
    @IBAction private func goToAuthorization(_ sender: Any) {
        if navigationController?.viewControllers.count == 2{
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
        else{
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension RegistrationViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if loginField.isFirstResponder{
            passowrdField.becomeFirstResponder()
        }
        else if passowrdField.isFirstResponder{
            emailField.becomeFirstResponder()
        }
        else{
            self.checkUser()
        }
        return true
    }
}

extension RegistrationViewController{
    private func checkUser(){
        if (!loginField.text!.isEmpty && !passowrdField.text!.isEmpty && !emailField.text!.isEmpty){
            
            signUpUser(login: loginField.text!, password: passowrdField.text!, email: emailField.text!)
        }
        else{
            self.showAlert(message: "Запоните все поля")
        }
    }
}
