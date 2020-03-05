//
//  ShoeDetailTableViewController.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 3/4/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit
import CoreData

class ShoeDetailTableViewController: UITableViewController {
    @IBOutlet weak var totalMiles: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    
    private let context = CoreDataStack.shared.mainContext
    
    var shoe: Shoe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateViews()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 60
        self.tableView.register(RunListHeaderView.self, forHeaderFooterViewReuseIdentifier:"RunListHeader")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadShoe()
        self.tableView.reloadData()
    }
    
    private func updateViews() {
//        self.totalMiles.text = self.shoe?.totalMiles
        self.nicknameLabel.text = self.shoe?.nickname
        self.brandLabel.text = self.shoe?.brand
    }
    
    private func reloadShoe() {
        guard let shoe = self.shoe else { return }
        self.context.refresh(shoe, mergeChanges: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddRunsSegue" {
            guard let addRunsVC = segue.destination as? RunHistoryTableViewController else { return }
            
            addRunsVC.shoe = self.shoe
        }
        
        if segue.identifier == "RunDetailSegue" {
            guard let runDetailVC = segue.destination as? RunDetailTableViewController else { return }
            
            if let indexPath = self.tableView.indexPathForSelectedRow,
                let runs = self.shoe?.runs?.array as? [Run]
            {
                runDetailVC.run = runs[indexPath.row]
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoe?.runs?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunCell", for: indexPath)
        
        let runs = self.shoe?.runs?.array as? [Run]
        
        if let run = runs?[indexPath.row] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
            
            let date = run.startDate.map { dateFormatter.string(from: $0) }

            let miles = String(run.miles)
            
            cell.textLabel?.text = date
            cell.detailTextLabel?.text = "\(miles) miles"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RunListHeader") as? RunListHeaderView
        view?.delegate = self
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "RunDetailSegue", sender: nil)
    }
}

extension ShoeDetailTableViewController: RunListHeaderViewDelegate {
    func addRunPressed() {
        self.performSegue(withIdentifier: "AddRunsSegue", sender: self)
    }
}
