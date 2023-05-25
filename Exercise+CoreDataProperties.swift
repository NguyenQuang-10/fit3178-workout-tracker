//
//  Exercise+CoreDataProperties.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 25/5/2023.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var desc: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var name: String?
    @NSManaged public var fbid: String?
    @NSManaged public var workout: NSSet?

}

// MARK: Generated accessors for workout
extension Exercise {

    @objc(addWorkoutObject:)
    @NSManaged public func addToWorkout(_ value: ExerciseSet)

    @objc(removeWorkoutObject:)
    @NSManaged public func removeFromWorkout(_ value: ExerciseSet)

    @objc(addWorkout:)
    @NSManaged public func addToWorkout(_ values: NSSet)

    @objc(removeWorkout:)
    @NSManaged public func removeFromWorkout(_ values: NSSet)

}

extension Exercise : Identifiable {

}
