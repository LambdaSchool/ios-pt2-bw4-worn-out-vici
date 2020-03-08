//
//  SummaryTableViewCell.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 3/1/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var totalMilesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWithRun(run: Run) {
        self.milesLabel.text = run.displayMiles
        self.nicknameLabel.text = run.shoe?.nickname
        self.brandLabel.text = run.shoe?.brand
        
        let miles = run.shoe.flatMap { $0.displayTotalMiles }

        self.totalMilesLabel.text = miles
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        let date = run.startDate.map { dateFormatter.string(from: $0) }
        self.timeLabel.text = date
    }
}
