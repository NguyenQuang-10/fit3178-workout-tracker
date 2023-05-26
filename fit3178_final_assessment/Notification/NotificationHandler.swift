//
//  WorkoutReminderDataManager.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 25/5/2023.
//

import Foundation
import UserNotifications

class NotificationHandler: NSObject, DatabaseListener {
    var listenerType: ListenerType = .workout
    var workouts: [Workout] = []
    var databaseController: DatabaseProtocol?
    
    override init() {
        super.init()
        databaseController?.addListener(listener: self)
    }
    
    func onWorkoutChange(change: DatabaseChange, workoutExercise: [Workout]) {
        workouts = workoutExercise
        scheduleNotification()
    }
    
    func onAllExercisesChange(change: DatabaseChange, exercises: [Exercise]) {
        return
    }
    
    func getSchedule() -> [Int] {
        var dateFreq: [Int] = [0,0,0,0,0,0,0]
        for workout in workouts {
            let dates = workout.schedule
            for dt in dates! {
                dateFreq[dt] += 1
            }
        }
        return dateFreq
    }
    
    func scheduleNotification() {
        print("date ran")
        let _: Dictionary = [
            0: "Monday",
            1: "Tuesday",
            2: "Wednesday",
            3: "Thursday",
            4: "Friday",
            5: "Saturday",
            6: "Sunday"
        ]
        
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        var dateFreq: [Int] = getSchedule()
        for i in 0...6 {
            // Create a notification content object
            let notificationContent = UNMutableNotificationContent()
            // Create its details
            notificationContent.title = "You have " + String(dateFreq[i]) + " scheduled workout today!"
//            notificationContent.subtitle = "See what workout(s) out you have today"
            notificationContent.body = "See what workout(s) out you have today"
            
            var date = DateComponents()
//            date.weekday = 4
            date.hour = 14
            date.minute = 42
            print(date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                    content: notificationContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
        
    }
    
    
}
