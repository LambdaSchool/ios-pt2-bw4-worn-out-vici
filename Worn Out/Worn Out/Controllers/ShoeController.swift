//
//  ShoeController.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 2/28/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import Foundation
import CoreData

class ShoeController {
    private let context = CoreDataStack.shared.mainContext
    
    func addShoe(brand: String, style: String?, nickname: String, id: UUID = UUID(), maxMiles: Double, isPrimary: Bool, totalMiles: Double = 0) {
        let newShoe = Shoe(brand: brand, style: style, nickname: nickname, maxMiles: maxMiles, isPrimary: isPrimary, totalMiles: totalMiles)
        
        // check if primary is true or not to change the primary shoes
        if newShoe.isPrimary {
            // fetch all shoes
            let shoes = self.fetchAllShoes()
            
            // set all shoes to be not primary
            for shoe in shoes {
                guard shoe != newShoe else { continue }
                shoe.isPrimary = false
            }
        }
        
        do {
            try self.context.save()
        } catch {
            print("Error saving managed object content: \(error)")
        }
    }
    
    func updateShoe(shoe: Shoe, brand: String, style: String?, nickname: String, maxMiles: Double, isPrimary: Bool) {
        shoe.brand = brand
        shoe.style = style
        shoe.nickname = nickname
        shoe.maxMiles = maxMiles
        shoe.isPrimary = isPrimary
        
        do {
            try self.context.save()
        } catch {
            print("Error saving managed object content: \(error)")
        }
    }
    
    func deleteShoe(shoe: Shoe) {
        // delete from local
        self.context.delete(shoe)
        
        do {
            try self.context.save()
        } catch {
            self.context.reset()
            print("Error saving managed object context: \(error)")
        }
    }
    
    func fetchPrimaryShoe() -> Shoe? {
        let fetchRequest: NSFetchRequest<Shoe> = Shoe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isPrimary = true")
        
        do {
            let shoes = try self.context.fetch(fetchRequest)
            return shoes.first
        } catch let error as NSError {
            print("Could not fetch: \(error)")
            return nil
        }
    }
    
    func fetchAllShoes() -> [Shoe] {
        let fetchRequest: NSFetchRequest<Shoe> = Shoe.fetchRequest()
        
        do {
            let shoes = try self.context.fetch(fetchRequest)
            return shoes
        } catch let error as NSError {
            print("Could not fetch: \(error)")
            return []
        }
    }
}
