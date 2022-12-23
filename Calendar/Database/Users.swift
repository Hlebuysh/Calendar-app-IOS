//
//  Users.swift
//  Calendar
//
//  Created by User on 02.12.2022.
//

import Firebase

var users: [String:[String:Any]] = [:]





func signInUser(email: String, password: String, complition: @escaping () -> Void){
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
        if error == nil{
//                    if !result!.user.isEmailVerified {
//                        self.showAlert(message: "Подтвердите свою почту")
//                    }
//                    else{
            complition()
//                    }
        }
        else{
            UIViewController.currentViewController().showAlert(message: error!.localizedDescription)
        }
    }
}

func signUpUser(login: String, password: String, email: String) -> Bool{
    var ret: Bool = false
    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
        if error == nil{
            if let result = result{
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                    if error != nil{
                        UIViewController.currentViewController().showAlert(message: error!.localizedDescription)
                        
                    }
                })
                
                
                let ref = Database.database(url: "https://calendarappforios-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users")
                ref.child(result.user.uid).updateChildValues(["login": login, "email": email])
            }
            ret = true
        }
        else{
            UIViewController.currentViewController().showAlert(message: error!.localizedDescription)
        }
    }
    return ret
}

func signOutUser(complition: @escaping () -> Void){
    do{
        try Auth.auth().signOut()
        complition()
    }catch let error as NSError
    {
        UIViewController.currentViewController().showAlert(message: error.localizedDescription)
    }
}

func getUsers(complition: @escaping () -> Void){
    Database.database(url: "https://calendarappforios-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users").observeSingleEvent(of: .value) { snapshot in
        let data = snapshot.value as! [String:[String:Any]]
        for (uid, udata) in data{
            print(uid)
            print(udata)
            users[uid] = ["login" : udata["login"] as! String, "events" : udata["events"] as? [String:Bool]]
        }
        complition()
    }
}

func findUser(uid: String) -> [String:Any]?{
    return users[uid] ?? nil
}
func findUser(login: String) -> String?{
    var result: String? = users.first(where: { (key: String, value: [String : Any]) in
        return value["login"] as! String == login
    })?.key
    return result
}

func currentUserID() -> String!{
    return Auth.auth().currentUser?.uid
}
func currentUser() -> String{
    return users[currentUserID()]!["login"] as! String
}

func didSignIn(complition: @escaping () -> Void){
    Auth.auth().addStateDidChangeListener { auth, user in
        if user != nil{
            complition()
        }
    }
}

func getUserBySubstring(substring: String, group: [String]) -> [String]{
    var result: [String] = []
    for (key, value) in users{
        if (value["login"] as! String).prefix(substring.count) == substring &&
            (group.first(where: { member in
                return member == key
            }) == nil)
        {
            result.append((value["login"] as! String))
        }
    }
    result.sort()
    return result
}

func changeLogin(newLogin: String){
    Database.database(url: "https://calendarappforios-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users").child(currentUserID()).child("login").setValue(newLogin)
    users[currentUserID()]!["login"] = newLogin
}

func changePassword(newPassword: String){
    Auth.auth().currentUser!.updatePassword(to: newPassword)
}
