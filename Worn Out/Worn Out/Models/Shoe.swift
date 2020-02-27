//
//  Shoe.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 2/27/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import Foundation

struct Shoe {
    let identifier: String
    let brand: String
    let style: String
    let nickname: String
    let maxMiles: Double = 350.00
    let runs: [Run]
    let isPrimary: Bool
    let totalMiles: Double
}
