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
    
    private let healthKitController = HealthKitController() // run controller
    private let shoeController = ShoeController()
    
    lazy var fetchedShoesController: NSFetchedResultsController<Shoe> = {
        // Fetch request
        let fetchRequest: NSFetchRequest<Shoe> = Shoe.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "totalMiles", ascending: false),
            NSSortDescriptor(key: "brand", ascending: true),
            NSSortDescriptor(key: "nickname", ascending: true)
        ]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }() // to store the variable after it runs
    
    lazy var fetchedRunsController: NSFetchedResultsController<Run> = {
        // Fetch request
        let fetchRequest: NSFetchRequest<Run> = Run.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "miles", ascending: true),
            NSSortDescriptor(key: "startDate", ascending: false)
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
        
        self.healthKitController.sync()
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
        
        if segue.identifier == "RunDetailSegue" {
            guard let runDetailVC = segue.destination as? RunDetailTableViewController else { return }
            
            runDetailVC.run =  self.fetchedRunsController.fetchedObjects?.last
        }
        
        if segue.identifier == "ShoeDetailSegue" {
            guard let shoeDetailVC = segue.destination as? ShoeDetailTableViewController else { return }
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                shoeDetailVC.shoe = self.fetchedShoesController.fetchedObjects?[indexPath.row]
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
            return self.fetchedRunsController.fetchedObjects?.isEmpty == true ? 0 : 1
        case 1:
            return self.fetchedShoesController.sections?.first?.numberOfObjects ?? 0
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
            
            if let run = self.fetchedRunsController.fetchedObjects?.last {
                cell.configureWithRun(run: run)
            }

            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoeCell", for: indexPath) as?
                ShoeListTableViewCell else {
                    return UITableViewCell()
            }
            let index = IndexPath(row: indexPath.row, section: 0)
            let shoe = self.fetchedShoesController.object(at: index)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            self.performSegue(withIdentifier: "RunDetailSegue", sender: nil)
        }
        
        if indexPath.section == 1 {
            self.performSegue(withIdentifier: "ShoeDetailSegue", sender: nil)
        }
    }
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
