//
//  ActiveWorkoutManager.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 7/6/2023.
//

import Foundation
import UserNotifications

// manages app behaviour when a workout is active
class ActiveWorkoutManager {
    
    var delegate: ActiveWorkoutDelegate? // the view controller that displaying the content of the active workout
    var exerciseSets: Dictionary<Exercise, [ExerciseSet]>? // the sets in the workout
    var workout: Workout? // the current active workout
    var exerciseArray: [Exercise] = [] // the exercises in the workout
    var active = false // true if there is currently an active workout
    var pendingNotiID: [String] = [] // stores all pending uuid of scheduled notification
    
    
    // load workout data to be display
    func loadWorkoutData(workout: Workout, exerciseSets: Dictionary<Exercise, [ExerciseSet]>){
        if active == true {
            timer?.invalidate()
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: pendingNotiID)
            pendingNotiID = []
        }
        
        self.exerciseSets = exerciseSets
        self.workout = workout
        exerciseArray = Array(exerciseSets.keys).sorted {(e1, e2) -> Bool in
            return exerciseSets[e1]![0].order < exerciseSets[e2]![0].order
        }
    }
    
    var timer: Timer? // used for timed callback
    
    // initializes the workout
    func startWorkout() {
        if active == true {
            timer?.invalidate()
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: pendingNotiID)
            pendingNotiID = []
        }
        active = true
        exerciseIndex = 0
        currentExercise = exerciseArray[exerciseIndex!]
        
        setIndex = 0
        currentSets = exerciseSets![exerciseArray[exerciseIndex!]]
        minuteLeft = Int(currentSets![setIndex!].duration)
        delegate?.updateMinute(min: minuteLeft!)
        secondLeft = 0
        delegate?.updateSecond(sec: secondLeft!)
        delegate?.updateSet(setData: currentSets![setIndex!], num: setIndex! + 1, total: currentSets!.count)
        delegate?.updateExercise(exercise: currentExercise!)
        
        scheduleNotification()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(workoutSubroutine), userInfo: nil, repeats: true)
    }
    
    var minuteLeft: Int?
    var secondLeft: Int?
    var currentExercise: Exercise?
    var currentSets: [ExerciseSet]?
    var setIndex: Int?
    var exerciseIndex: Int?
    
    // subroutine that runs to update the workout status
    @objc
    func workoutSubroutine() {
        if secondLeft! > 0 {
            secondLeft! -= 1
            delegate?.updateSecond(sec: secondLeft!)
        } else if minuteLeft! > 0 {
            minuteLeft! -= 1
            secondLeft! = 59
            delegate?.updateMinute(min: minuteLeft!)
            delegate?.updateSecond(sec: secondLeft!)
        } else if setIndex! < currentSets!.count - 1 {
            setIndex! += 1
            // reset time for new set
            minuteLeft = Int(currentSets![setIndex!].duration)
            delegate?.updateSecond(sec: secondLeft!)
            secondLeft = 0
            delegate?.updateMinute(min: minuteLeft!)
            
            // update set for delegate
            let currSet = currentSets![setIndex!]
            delegate?.updateSet(setData: currSet, num: setIndex! + 1, total: currentSets!.count)
            
        } else if exerciseIndex! < exerciseArray.count - 1{
            exerciseIndex! += 1
            setIndex = 0
            currentExercise = exerciseArray[exerciseIndex!]
            currentSets = exerciseSets![currentExercise!]
            
            delegate?.updateExercise(exercise: currentExercise!)
            delegate?.updateSet(setData: currentSets![setIndex!], num: setIndex! + 1, total: currentSets!.count)
            
            minuteLeft = Int(currentSets![setIndex!].duration)
            delegate?.updateSecond(sec: secondLeft!)
            secondLeft = 0
            delegate?.updateMinute(min: minuteLeft!)
            
        } else {
            if active == true {
                print("Finished workout")
                finishWorkout()
            }
        }
        
    }
    
    // finishes the workout
    func finishWorkout() {
        active = false
        timer?.invalidate()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: pendingNotiID)
        pendingNotiID = []
        timer?.invalidate()
        delegate?.finishWorkout()
    }
    
    // schedule the notification when set and exercises change
    func scheduleNotification() {
        var delay = 1
        for e in exerciseArray {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delay), repeats: false)
            
            var notiContent = UNMutableNotificationContent()
            notiContent.title = "Next exercise: " + e.name!
            notiContent.body = String(exerciseSets![e]!.count) + " sets"
            
            let newExNotiUUID = UUID().uuidString
            let req = UNNotificationRequest(identifier: newExNotiUUID, content: notiContent, trigger: trigger)
            UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
            pendingNotiID.append(newExNotiUUID)
            
            for s in exerciseSets![e]! {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delay), repeats: false)
                
                var notiContent = UNMutableNotificationContent()
                notiContent.title = "Next set for " + e.name!
                notiContent.body = String(s.repetition) + " reps of " + String(s.intensity) + " " + String(s.unit!) + " for " + String(s.duration) + " minute(s)"
                
                let newSetNotiUUID = UUID().uuidString
                let req = UNNotificationRequest(identifier: newSetNotiUUID, content: notiContent, trigger: trigger)
                UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
                pendingNotiID.append(newSetNotiUUID)
                
                delay += Int(s.duration) * 60
            }
        }
    }
    
    func timeskip(secondPassed: Int) {
        timer?.invalidate()
        for _ in 0...secondPassed {
            workoutSubroutine()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(workoutSubroutine), userInfo: nil, repeats: true)
    }
    
}
