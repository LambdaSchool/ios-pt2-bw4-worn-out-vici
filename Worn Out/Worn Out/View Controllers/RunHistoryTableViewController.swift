//
//  RunHistoryTableViewController.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 3/4/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit
import CoreData

class RunHistoryTableViewController: UITableViewController {
    
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    
    private let context = CoreDataStack.shared.mainContext
    
    private lazy var fetchedRunsController: NSFetchedResultsController<Run> = {
        // Fetch request
        let fetchRequest: NSFetchRequest<Run> = Run.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: false)
        ]
        
        fetchRequest.predicate = NSPredicate(format: "shoe == nil")
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }() // to store the variable after it runs
    
    var shoe: Shoe?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelection = true
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let indexPaths = self.tableView.indexPathsForSelectedRows
        
        if let runs = indexPaths?.compactMap({ self.fetchedRunsController.fetchedObjects?[$0.row] }) {
            for run in runs {
                run.shoe = self.shoe
            }
        }
       
        do {
            try self.context.save()
        } catch {
            print("Error saving managed object content: \(error)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedRunsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunCell", for: indexPath)
        
        let run = self.fetchedRunsController.fetchedObjects?[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        let date = run?.startDate.map { dateFormatter.string(from: $0) }
        let miles = run.map { String($0.miles) }
        
        cell.textLabel?.text = date
        cell.detailTextLabel?.text = miles
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}

extension RunHistoryTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}
