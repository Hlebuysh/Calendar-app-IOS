//
//  AppDelegate.swift
//  Calendar
//
//  Created by User on 31.10.2022.
//

import UIKit
import FirebaseCore
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var isDropDownList = false
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        Auth.auth().addStateDidChangeListener{ (auth, user) in
//            if user == nil{
//                self.showAuthorization()
//            }
//        }
        return true
    }
//    private func showAuthorization(){
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthorizationViewController") as! AuthorizationViewController
//        self.window?.rootViewController?.present(vc, animated: true)
//    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

