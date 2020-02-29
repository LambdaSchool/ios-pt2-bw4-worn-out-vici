//
//  ShoeController.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 2/28/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import Foundation

class ShoeController {
    func addShoe(for brand: String, style: String, nickname: String?, id: UUID, maxMiles: Double?, isPrimary: Bool, totalMiles: Double?) {
        let _ = Shoe(brand: brand, nickname: nickname, maxMiles: maxMiles ?? 350.00, isPrimary: isPrimary, totalMiles: totalMiles ?? 0.0)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object content: \(error)")
        }
    }
    
    func updateShoe(for shoe: Shoe, brand: String, style: String, nickname: String, maxMiles: Double, isPrimary: Bool) {
        shoe.brand = brand
        shoe.style = style
        shoe.nickname = nickname
        shoe.maxMiles = maxMiles
        shoe.isPrimary = isPrimary
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object content: \(error)")
        }
    }
    
    func deleteShoe(shoe: Shoe) {
        // delete from local
        let moc = CoreDataStack.shared.mainContext
        moc.delete(shoe)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving managed object context: \(error)")
        }
    }
    
    func totalMiles(shoe: Shoe, run:Run) -> Double {
        // get the current miles from the shoe
        let currentMiles = shoe.totalMiles
        
        // get the current miles from the run
        let runMiles = run.miles
        
        // total the miles
        return currentMiles + runMiles
    }
}
