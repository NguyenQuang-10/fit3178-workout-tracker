//
//  WorkoutRecording+CoreDataProperties.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 8/6/2023.
//
//

import Foundation
import CoreData


extension WorkoutRecording {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutRecording> {
        return NSFetchRequest<WorkoutRecording>(entityName: "WorkoutRecording")
    }

    @NSManaged public var uuid: String?
    @NSManaged public var title: String?

}

extension WorkoutRecording : Identifiable {

}
