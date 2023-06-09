//
//  ConfigureExercisesDelegate.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 11/5/2023.
//

import Foundation

// delegate responsible for the configuring of an exercise
protocol ConfigureExerciseDelegate {
    var exercises: Dictionary<Exercise, [ExerciseSetStruct]> {get set}
}
