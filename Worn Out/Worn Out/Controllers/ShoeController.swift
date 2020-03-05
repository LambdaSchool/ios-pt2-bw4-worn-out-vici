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
    
    func addShoe(brand: String, style: String, nickname: String?, id: UUID = UUID(), maxMiles: Double, isPrimary: Bool, totalMiles: Double = 0) {
        let _ = Shoe(brand: brand, nickname: nickname, maxMiles: maxMiles, isPrimary: isPrimary, totalMiles: totalMiles)
        
        do {
            try self.context.save()
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
}
