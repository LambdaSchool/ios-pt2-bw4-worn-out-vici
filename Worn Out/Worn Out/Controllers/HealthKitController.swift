//
//  HealthKitController.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 2/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import HealthKit

class HealthKitController {
    func retrieveWorkouts() {
        // Predicate to read only running workouts
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        
        // Order the workouts by date
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // Create the query
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(),
                                        predicate: predicate,
                                        limit: HKObjectQueryNoLimit,
                                        sortDescriptors: [sortDescriptor]) { (query, results, error) in
                                            if let results = results {
                                                print("Retrieved the following workouts")
                                                for sample in results {
                                                    let workout = sample
                                                    print("\(workout)")
                                                }
                                            } else {
                                                print("Error retrieving workouts")
                                            }
        }
        
        // Execute the query
        HKHealthStore().execute(sampleQuery)
    }
}
