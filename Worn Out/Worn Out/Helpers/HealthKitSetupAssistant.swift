//
//  HealthKitSetupAssistant.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 2/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import HealthKit

class HealthKitSetupAssistant {
    private enum HealthKitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    class func authorizeHealtKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        // Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitSetupError.notAvailableOnDevice)
            return
        }
        
        // Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = [HKObjectType.workoutType()]
        
        let healtKitTypesToRead: Set<HKObjectType> = [HKObjectType.workoutType()]
        
        // Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healtKitTypesToRead) { (success, error) in
            completion(success, error)
        }
    }
}
