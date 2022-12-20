//
//  TabController.swift
//  Calendar
//
//  Created by User on 20.12.2022.
//

import UIKit

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if (!isRequests()){
            self.viewControllers?.remove(at: 3)
        }
    }
}
