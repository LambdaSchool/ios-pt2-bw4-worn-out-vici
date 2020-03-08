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
    @IBOutlet weak var maxMilesLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    private let context = CoreDataStack.shared.mainContext
    
    var shoe: Shoe?
    var shoeController :ShoeController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateViews()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(RunListHeaderView.self, forHeaderFooterViewReuseIdentifier:"RunListHeader")
        
        self.progressView.layer.cornerRadius = 5
        self.progressView.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.reloadShoe()
        self.tableView.reloadData()
        self.setProgress()
    }
    
    private func updateViews() {
        let miles = self.shoe.flatMap { $0.displayTotalMiles }
        let maxMiles = self.shoe.flatMap { $0.displayMaxMiles }
   
        self.totalMiles.text = miles
        self.maxMilesLabel.text = maxMiles.map { "\($0) miles" }
        self.nicknameLabel.text = self.shoe?.nickname
        self.brandLabel.text = self.shoe?.brand
    }
    
    private func setProgress() {
        let miles = self.shoe.map { $0.calculateTotalMiles() } ?? 0
        let maxMiles = self.shoe.map { $0.maxMiles } ?? 350
        let progress = Float(miles / maxMiles)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.progressView.setProgress(progress, animated: true)
        }, completion: nil)
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
        
        if segue.identifier == "EditShoeSegue" {
            guard let nc = segue.destination as? UINavigationController,
                let addShoeVC = nc.topViewController as? AddShoeTableViewController else {
                    return
            }
            
            addShoeVC.delegate = self
            addShoeVC.shoe = self.shoe
            addShoeVC.shoeController = self.shoeController
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
            
            cell.textLabel?.text = date
            cell.detailTextLabel?.text = run.displayMiles.map { "\($0) miles" }
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RunListHeader") as? RunListHeaderView
        view?.delegate = self
        return view
    }
    
    // Need this when there is a header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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

extension ShoeDetailTableViewController: AddShoeTableViewControllerDelegate {
    func shoeWasUpdated(_ shoe: Shoe) {
        self.updateViews()
    }
}
