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
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.tableView.estimatedRowHeight = 60
        self.tableView.register(ShoeListTableViewCell.self, forCellReuseIdentifier: "ShoeCell")
        
        // Register the custom header view
        self.tableView.register(ShoeListHeaderView.self, forHeaderFooterViewReuseIdentifier: "ShoeListHeader")
        
        HealthKitSetupAssistant.authorizeHealtKit { (isAuthorized, error) in
            if isAuthorized {
                self.healthKitController.sync()
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as?
                SummaryTableViewCell else {
                    return UITableViewCell()
            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoeCell", for: indexPath) as?
                ShoeListTableViewCell else {
                    return UITableViewCell()
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 50
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ShoeListHeader") as! ShoeListHeaderView
        return view
    }
}

extension MainViewController: UITableViewDelegate {
    
}
