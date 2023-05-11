//
//  Exercise+CoreDataProperties.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 11/5/2023.
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

}

extension Exercise : Identifiable {

}
