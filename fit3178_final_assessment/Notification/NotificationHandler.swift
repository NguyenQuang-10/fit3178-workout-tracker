//
//  WorkoutReminderDataManager.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 25/5/2023.
//


import Foundation
import UserNotifications

// Responsible for handling the scheduling of the notification for workout reminder
// Depending on the schedule of a workout, schedule a notification at 8AM for each date of the week that workout is scheduled for
class NotificationHandler: NSObject, DatabaseListener {
    var listenerType: ListenerType = .workout // listener type for database controller
    var workouts: [Workout] = [] // all workouts to schedule notification for
    var databaseController: DatabaseProtocol? // database controller to retrieve exercise
    
    /*
     Initialiser
     */
    override init() {
        super.init()
        databaseController?.addListener(listener: self)
    }
    
    /*
     Update workouts when database changes
     */
    func onWorkoutChange(change: DatabaseChange, workoutExercise: [Workout]) {
        workouts = workoutExercise
        scheduleNotification()
    }
    
    /*
     Doesn't need data from exercises
     */
    func onAllExercisesChange(change: DatabaseChange, exercises: [Exercise]) {
        return
    }
    
    // return the the number of workout for each week date i.e at index i is the number of workout happening on date i + 2
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
    
    // store the uuid for notification of each weekdate
    var notifcationUUIDforDate: Dictionary<Int, String> = [:]
    
    func scheduleNotification() {
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
        
        // configure notification content schedule the notification for 8AM on the date of the workout
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
                date.hour = 8
                date.minute = 0
                date.weekday = i + 2 // weekdays start from 2 for Monday
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
