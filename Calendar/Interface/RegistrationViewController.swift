//
//  RegistrationViewController.swift
//  Calendar
//
//  Created by User on 08.11.2022.
//

import UIKit
import Firebase

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
            Auth.auth().createUser(withEmail: emailField.text!, password: passowrdField.text!) { (result, error) in
                if error == nil{
                    if let result = result{
                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                            if error != nil{
                                self.showAlert(message: error!.localizedDescription)
                                
                            }
                        })
                        
                        
                        let ref = Database.database(url: "https://calendarappforios-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users")
                        ref.child(result.user.uid).updateChildValues(["login": self.loginField.text!, "email": self.emailField.text!])
                    }
                    self.goToAuthorization(self)
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
}
