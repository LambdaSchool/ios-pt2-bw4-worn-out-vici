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
    var displayMiles: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesSignificantDigits = true
        return numberFormatter.string(from: NSNumber(value: self.calculateTotalMiles()))
    }
    
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
        // for run in shoe.runs {
        //    totalMiles += run.miles
        // }
        // code above is the same like below
        let runs = self.runs?.array as? [Run] // cast it from NSOrderedSet to [Run]
        let totalMiles = runs?.reduce(0) { curr, next in
            curr + next.miles
        }
        
        if let totalMiles = totalMiles, totalMiles != self.totalMiles {
            self.managedObjectContext?.perform {
                self.totalMiles = totalMiles
                
                do {
                    try self.managedObjectContext?.save()
                } catch let error {
                    print("Error saving managed object content: \(error)")
                }
            }
        }
        
        // total the miles
        return totalMiles ?? 0
    }
}
