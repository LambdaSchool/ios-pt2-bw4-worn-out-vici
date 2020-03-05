//
//  Shoe+Convenience.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 2/28/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import Foundation
import CoreData

extension Shoe {
    convenience init(identifier: UUID = UUID(), brand: String, style: String? = nil, nickname: String?, maxMiles: Double, isPrimary: Bool, totalMiles: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.identifier = identifier
        self.brand = brand
        self.style = style
        self.nickname = nickname
        self.maxMiles = maxMiles
        self.isPrimary = isPrimary
        self.totalMiles = totalMiles
    }
    
    func calculateTotalMiles() -> Double {
        // get the current miles from the shoe
        // let currentMiles = shoe.totalMiles
        
        // get the current miles from the run
        // var totalMiles: Double = 0
        //        for run in shoe.runs {
        //          totalMiles += run.miles
        //        }
            
        // code above is the same like below
        let runs = self.runs?.array as? [Run] // cast it from NSOrderedSet to [Run]
        let totalMiles = runs?.reduce(0) { curr, next in
            curr + next.miles
        }
        
        // total the miles
        return totalMiles ?? 0
    }
}
