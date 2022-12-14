//
//  Users.swift
//  Calendar
//
//  Created by User on 02.12.2022.
//

import Firebase

fileprivate var users: [String:String] = [:]

extension UIViewController {
    class func currentViewController(base: UIViewController! = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController! {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}

func signInUser(email: String, password: String) -> Bool{
    var ret: Bool = false
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
        if error == nil{
//                    if !result!.user.isEmailVerified {
//                        self.showAlert(message: "Подтвердите свою почту")
//                    }
//                    else{
                ret = true
//                    }
        }
        else{
            UIViewController.currentViewController().showAlert(message: error!.localizedDescription)
        }
    }
    return ret
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

func signOutUser(){
    do{
        try Auth.auth().signOut()
    }catch let error as NSError
    {
        UIViewController.currentViewController().showAlert(message: error.localizedDescription)
    }
}

func getUsers(){
    Database.database(url: "https://calendarappforios-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users").observeSingleEvent(of: .value) { snapshot in
        let data = snapshot.value as! [String:[String:Any]]
        for (uid, udata) in data{
            users[uid] = (udata["login"] as! String)
        }
    }
}

func findUser(uid: String) -> String?{
    return users[uid] ?? nil
}
