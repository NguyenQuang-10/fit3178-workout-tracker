//
//  Exercise.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 10/5/2023.
//

import Foundation
import FirebaseFirestoreSwift

class FirebaseExercise: NSObject, Codable {
    @DocumentID var id: String?
    var name: String?
    var desc: String?
    var imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case desc
        case imageURL
    }
}
