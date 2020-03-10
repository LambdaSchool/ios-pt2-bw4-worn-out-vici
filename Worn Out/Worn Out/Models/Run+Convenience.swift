//
//  Run+Convenience.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 3/5/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import Foundation
import CoreData

extension Run {
    var displayMiles: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter.string(from: NSNumber(value: self.miles))
    }
}
