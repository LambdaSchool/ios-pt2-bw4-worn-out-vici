//
//  RunRepresentation.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 2/27/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import Foundation

struct RunRepresentation: Codable {
    let workoutIdentifier: String
    let startDate: Date
    let miles: Double
}
