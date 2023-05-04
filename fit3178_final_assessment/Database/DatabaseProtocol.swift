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
    func onWorkoutChange(change: DatabaseChange, workoutExercise: [Exercise])
    func onAllExercisesChange(change: DatabaseChange, exercises: [Exercise])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func addExercise(name: String, sets: NSArray) -> Exercise
    func deleteExercise(exercise: Exercise)
    func addWorkout(name: String, schedule: NSArray) -> Workout
    func addExerciseToWorkout(exercise: Exercise, workout: Workout)
}
