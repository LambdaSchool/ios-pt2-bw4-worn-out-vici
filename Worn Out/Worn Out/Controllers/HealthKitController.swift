//
//  HealthKitController.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 2/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import CoreData
import HealthKit

class HealthKitController {
    private let context = CoreDataStack.shared.mainContext
    private let shoeController = ShoeController()
    
    func sync() {
        self.retrieveWorkouts { workouts in
            guard let workouts = workouts as? [HKWorkout],   // Retrieve Workouts from HealthKit
                let runs = self.retrieveRuns() else          // Retrieve CoreData Runs
            {
                return
            }

            let runIdentifiersArray = runs.compactMap { $0.workoutIdentifier }
            let runIdentifiersSet = Set<UUID>(runIdentifiersArray)
            
            // filtering workouts that don't have a run in CoreData
            let workoutsToCreate = workouts.filter { workout -> Bool in
                return !runIdentifiersSet.contains(workout.uuid)
            }

            let workoutIdentifiersArray = workouts.map { $0.uuid }
            let workoutIdentifiersSet = Set<UUID>(workoutIdentifiersArray)
            
            // filtering runs that don't have a workout in HealthKit
            let runsToDelete = runs.filter { run -> Bool in
                guard let uuid = run.workoutIdentifier else { return false }
                return !workoutIdentifiersSet.contains(uuid)
            }
            
            // filtering runs that have a workout to be updated
            let runsToUpdate = runs.filter { run -> Bool in
                guard let uuid = run.workoutIdentifier else { return false }
                return workoutIdentifiersSet.contains(uuid)
            }

            // create a run
            for workout in workoutsToCreate {
                let run = Run(context: self.context)
                run.workoutIdentifier = workout.uuid
                run.miles = workout.totalDistance?.doubleValue(for: .mile()) ?? 0
                run.startDate = workout.startDate
                
                // set the primary shoes for the new run
                run.shoe = self.shoeController.fetchPrimaryShoe()
            }
            
            // delete a run
            for run in runsToDelete {
                self.context.delete(run)
            }
            
            var workoutDictionary = [UUID: HKWorkout]()
            for workout in workouts {
                workoutDictionary[workout.uuid] = workout
            }
            
            // update a run
            for run in runsToUpdate {
                guard let uuid = run.workoutIdentifier else { continue }
                let workout = workoutDictionary[uuid]
                run.miles = workout?.totalDistance?.doubleValue(for: .mile()) ?? 0
                run.startDate = workout?.startDate
            }
            
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Could not save: \(error)")
            }
        }
    }
    
    // MARK: - Private Functions
    
    private func retrieveWorkouts(completion: @escaping ([HKSample]) -> Void) {
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
                                                DispatchQueue.main.async {
                                                    completion(results)
                                                }
                                            } else {
                                                print("Error retrieving workouts")
                                            }
        }
        
        // Execute the query
        HKHealthStore().execute(sampleQuery)
    }
    
    private func retrieveRuns() -> [Run]? {
        let fetchRequest: NSFetchRequest<Run> = Run.fetchRequest()
        
        do {
            let runs = try self.context.fetch(fetchRequest)
            return runs
        } catch let error as NSError {
            print("Could not fetch: \(error)")
            return nil
        }
    }
}
