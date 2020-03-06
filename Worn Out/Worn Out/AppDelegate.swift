//
//  AppDelegate.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 2/25/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit
import HealthKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let store = HKHealthStore()
    private let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        self.notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        
        // https://developer.apple.com/documentation/healthkit/hkobserverquery/executing_observer_queries
        let runsType = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        let query = HKObserverQuery(sampleType: runsType, predicate: predicate) { (query, completion, error) in
            if let error = error {
                print("Error getting the new workouts: \(error)")
                return
            }
            
            self.sendNotification()
                        
            // If you have subscribed for background updates you must call the completion handler here.
            completion()
        }
        store.execute(query)
        store.enableBackgroundDelivery(for: runsType, frequency: .immediate) { (success, error) in
            if success {
                print("success")
            } else if let error = error {
                print("\(error.localizedDescription)")
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func sendNotification() {
        // Create new notifcation content instance
        let notificationContent = UNMutableNotificationContent()
        
        // Add the content to the notification content
        notificationContent.title = "Test"
        notificationContent.body = "Test body"

        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: nil)
        self.notificationCenter.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
