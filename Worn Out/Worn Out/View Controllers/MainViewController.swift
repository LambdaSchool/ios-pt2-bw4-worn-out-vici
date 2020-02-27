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
                self.healthKitController.retrieveWorkouts()
            }
        }

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
