//
//  Workout+CoreDataProperties.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 25/5/2023.
//
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var name: String?
    @NSManaged public var schedule: [Int]?
    @NSManaged public var fbid: String?
    @NSManaged public var exercises: NSSet?

}

// MARK: Generated accessors for exercises
extension Workout {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseSet)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseSet)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

extension Workout : Identifiable {

}
