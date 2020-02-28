//
//  MainViewController.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 2/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit
import HealthKit

class MainViewController: UIViewController {
    
    let healthKitController = HealthKitController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HealthKitSetupAssistant.authorizeHealtKit { (isAuthorized, error) in
            if isAuthorized {
                self.healthKitController.sync()
            }
        }
    }
}
