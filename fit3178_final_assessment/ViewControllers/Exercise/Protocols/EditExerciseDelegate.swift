//
//  EditExerciseDelegate.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 11/5/2023.
//

import Foundation

// delegate responsible for editing an exercise
protocol EditExerciseDelegate {
    func getSetsForExercise(exercise: Exercise) -> [ExerciseSetStruct]
    func updateSetsForExercise(exercise: Exercise, exericseSets: [ExerciseSetStruct])
}
