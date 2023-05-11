//
//  ExerciseSet+CoreDataProperties.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 11/5/2023.
//
//

import Foundation
import CoreData


extension ExerciseSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseSet> {
        return NSFetchRequest<ExerciseSet>(entityName: "ExerciseSet")
    }

    @NSManaged public var intensity: Int16
    @NSManaged public var repetition: Int16
    @NSManaged public var unit: String?
    @NSManaged public var workout: Workout?
    @NSManaged public var exercise: Exercise?

}

extension ExerciseSet : Identifiable {

}
