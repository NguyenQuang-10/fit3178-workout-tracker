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
                dateFreq[dt - 2] += 1 // dates starts from 2 for Monday
            }
        }
        return dateFreq
    }
    
    var notifcationUUIDforDate: Dictionary<Int, String> = [:]
    
    func scheduleNotification() {
        print("date ran")
        // CHANGED FROM OLD, THIS IS THE CORRECT WEEKDAY TO INT
        let _: Dictionary = [
            2: "Monday",
            3: "Tuesday",
            4: "Wednesday",
            5: "Thursday",
            6: "Friday",
            7: "Saturday",
            8: "Sunday"
        ]
        
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let dateFreq: [Int] = getSchedule()
        for i in 0...6 {
            if dateFreq[i] > 0 {
                // Create a notification content object
                let notificationContent = UNMutableNotificationContent()
                // Create its details
                notificationContent.title = "You have " + String(dateFreq[i]) + " scheduled workout today!"
                //            notificationContent.subtitle = "See what workout(s) out you have today"
                notificationContent.body = "See what workout(s) out you have today"
                
                var date = DateComponents()
                date.hour = 19
                date.minute = 17
                date.weekday = i + 2 // weekdays start from 2 for Monday
                print(date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                
                if let uuid = notifcationUUIDforDate[i+2] {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uuid])
                }
                let newUuid = UUID().uuidString
                notifcationUUIDforDate[i+2] = newUuid
                let request = UNNotificationRequest(identifier: newUuid,
                                                    content: notificationContent, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
        
        
    }
    
    
}
