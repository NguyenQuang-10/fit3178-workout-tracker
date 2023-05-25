//
//  Workout.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 10/5/2023.
//

import Foundation
import FirebaseFirestoreSwift

class FirebaseWorkout: NSObject, Codable {
    @DocumentID var id: String?
    var name: String?
    var schedule: [Int] = []
    var exercises: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case schedule
        case exercises
    }
}
