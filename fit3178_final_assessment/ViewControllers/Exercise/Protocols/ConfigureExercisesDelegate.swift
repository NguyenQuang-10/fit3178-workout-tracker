//
//  ConfigureExercisesDelegate.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 11/5/2023.
//

import Foundation


protocol ConfigureExerciseDelegate {
    var exercises: Dictionary<Exercise, [ExerciseSetStruct]> {get set}
}
