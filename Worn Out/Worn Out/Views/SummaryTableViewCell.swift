//
//  SummaryTableViewCell.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 3/1/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var totalMilesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWithRun(run: Run) {
        self.totalMilesLabel.text = String(run.miles)
        self.nicknameLabel.text = run.shoe?.nickname
        self.brandLabel.text = run.shoe?.brand
//        self.timeLabel.text = run.startDate
    }
}
