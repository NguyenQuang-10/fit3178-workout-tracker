//
//  DecodedAPIExercise.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 17/5/2023.
//

import Foundation

/**
 Codable for decoding exercise details we retrieve from the API
 */
class ExerciseAPIData: NSObject, Decodable {
    var name: String
    var type: String
    var muscle: String
    var equipment: String
    var difficulty: String
    var instructions: String
    
    
    private enum ExerciseKeys: String, CodingKey {
        case name
        case type
        case muscle
        case equipment
        case difficulty
        case instructions
    }
    
}
