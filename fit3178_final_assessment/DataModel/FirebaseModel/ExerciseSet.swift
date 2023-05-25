//
//  ExerciseSet.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 25/5/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseExerciseSet: NSObject, Codable {
    @DocumentID var id: String?
    var intensity: Int16?
    var repetition: Int16?
    var unit: String?
    var exercise: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case intensity
        case repetition
        case unit
        case exercise
    }
}
