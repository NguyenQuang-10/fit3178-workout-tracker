//
//  ActiveWorkoutDelegate.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 7/6/2023.
//

import Foundation
protocol ActiveWorkoutDelegate {
    
    func updateSecond(sec: Int)
    func updateMinute(min: Int)
    func updateSet(setData: ExerciseSet, num: Int, total: Int)
    func updateExercise(exercise: Exercise )
    func finishWorkout()
    
}
