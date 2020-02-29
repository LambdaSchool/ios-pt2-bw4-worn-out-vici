//
//  ShoeRepresentation.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 2/27/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import Foundation

struct ShoeRepresentation: Codable {
    let identifier: String
    let brand: String
    let style: String?
    let nickname: String
    let maxMiles: Double
    let isPrimary: Bool
    let totalMiles: Double
}
