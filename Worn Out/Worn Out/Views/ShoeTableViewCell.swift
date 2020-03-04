//
//  ShoeTableViewCell.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 3/3/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit

class ShoeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nicknameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
