//
//  ActiveWorkoutDelegate.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 7/6/2023.
//

import Foundation

// for delegate of the activeWorkoutManager, these will be called by the manager
protocol ActiveWorkoutDelegate {
    
    func updateSecond(sec: Int) // update after every second is passed
    func updateMinute(min: Int) // update when a minute is passed
    func updateSet(setData: ExerciseSet, num: Int, total: Int) // update when changed to a new set
    func updateExercise(exercise: Exercise ) // update when exercise is changed
    func finishWorkout() // end the workout
    
}
