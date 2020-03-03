//
//  MainViewController.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 2/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit
import HealthKit
import CoreData

class MainViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let healthKitController = HealthKitController()
    private let shoeController = ShoeController()
    
    lazy var fetchedResultController: NSFetchedResultsController<Shoe> = {
        // Fetch request
        let fetchRequest: NSFetchRequest<Shoe> = Shoe.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "brand", ascending: true),
            NSSortDescriptor(key: "nickname", ascending: true),
            NSSortDescriptor(key: "totalMiles", ascending: true)
        ]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }() // to store the variable after it runs

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddShoeSegue" {
            guard let nc = segue.destination as? UINavigationController,
                let addShoeVC = nc.topViewController as? AddShoeTableViewController else {
                    return
            }
            
            addShoeVC.shoeController = self.shoeController
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
            return self.fetchedResultController.sections?.first?.numberOfObjects ?? 0
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
            let index = IndexPath(row: indexPath.row, section: 0)
            let shoe = self.fetchedResultController.object(at: index)
            cell.configureWithShoe(shoe: shoe)
            
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
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ShoeListHeader") as? ShoeListHeaderView
        view?.delegate = self
        return view
    }
}

extension MainViewController: UITableViewDelegate {
    
}

extension MainViewController: ShoeListHeaderViewDelegate {
    func addShoePressed() {
        self.performSegue(withIdentifier: "AddShoeSegue", sender: self)
    }
}

extension MainViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}
