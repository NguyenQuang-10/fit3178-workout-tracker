//
//  DatabaseProtocol.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 4/5/2023.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case exercise
    case workout
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onWorkoutChange(change: DatabaseChange, workoutExercise: [Workout])
    func onAllExercisesChange(change: DatabaseChange, exercises: [Exercise])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func addExercise(name: String, desc: String, imageURL: String, id: String) -> AnyObject
    func deleteExercise(exercise: Exercise)
    func addWorkout(name: String, schedule: [WeekDates], setData: Dictionary<Exercise, [ExerciseSetStruct]>, id: String) -> AnyObject
    func addExerciseSet(rep: Int, intensity: Int, unit: String, exerciseID: String, workoutID: String) -> AnyObject
    
    func clearAllData()
    func syncWithOnline()
}
